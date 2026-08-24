/**
 * Baidu Map HarmonyOS NEXT native embed for uni-app.
 *
 * This file is intentionally limited to map rendering and map-local events.
 * Location permissions, coordinate conversion, reverse geocoding, navigation,
 * and application business state remain the responsibility of the host app.
 */
import {
  MapComponent,
  MapController,
  MapOptions,
  SysEnum,
  MapEvent,
  TMapViewEvent,
  Marker,
  ImageEntity,
  PopView,
  HorizontalLayout,
  VerticalLayout,
  BaseGroupUI,
  LabelUI,
  TextStyle,
} from '@bdmap/navi_map'
import { Initializer, MapSDKConfigBuilder, LatLng } from '@bdmap/navi_map'
import { defineNativeEmbed, NativeEmbedBuilderOptions } from '@dcloudio/uni-app-runtime'
import common from '@ohos.app.ability.common'

interface CenterPoint {
  lat: number
  lon: number
}

interface StoreMarkerOptions {
  lat: number
  lon: number
  logo?: string
  name?: string
  distance?: string
  address?: string
}

interface BaiduMapBuilderOptions extends NativeEmbedBuilderOptions {
  apiKey: string
  /** Must be true only after the host app has obtained user consent. */
  privacyAgreed: boolean
  /** OAID collection is disabled by default. */
  oaidEnabled?: boolean
  /** Initial map center in Baidu BD09 coordinates. */
  center?: CenterPoint
  /** Initial zoom level. */
  zoom?: number
  /** Host-provided fallback marker icon in rawfile:// form. */
  defaultMarkerIcon?: string
  /** Optional single marker rendered by the plugin. */
  storeMarker?: StoreMarkerOptions
}

interface MapReadyDetail {
  err: Error | null
  /** Native controllers are intentionally not serialized across the embed boundary. */
  controller: MapController | null
}

interface MapReadyEvent {
  detail: MapReadyDetail
}

interface CenterChangeDetail {
  lat: number
  lon: number
}

interface CenterChangeEvent {
  detail: CenterChangeDetail
}

let sdkInitialized: boolean = false
let sdkApiKey: string = ''
let sdkInitialization: Promise<void> | null = null

/**
 * Initialize the vendor SDK once per application process.
 *
 * The promise guard prevents multiple embeds mounted in the same render pass
 * from racing through the vendor initializer. A different API key in the
 * same process is rejected because the SDK is process-global.
 */
async function initializeSdk(
  apiKey: string,
  privacyAgreed: boolean,
  oaidEnabled: boolean,
  context: common.UIAbilityContext,
): Promise<void> {
  if (!apiKey) {
    throw new Error('Baidu Map apiKey is required.')
  }
  if (!privacyAgreed) {
    throw new Error('Baidu Map SDK initialization requires explicit privacy consent.')
  }

  if (sdkInitialized) {
    if (sdkApiKey !== apiKey) {
      throw new Error('Baidu Map SDK was already initialized with a different apiKey.')
    }
    return
  }

  if (sdkInitialization) {
    await sdkInitialization
    if (sdkApiKey !== apiKey) {
      throw new Error('Baidu Map SDK was already initialized with a different apiKey.')
    }
    return
  }

  sdkInitialization = (async (): Promise<void> => {
    const config = new MapSDKConfigBuilder()
      .setPrivacyAgreed(privacyAgreed)
      .setOaidEnabled(oaidEnabled)
      .build()

    await Initializer.configure(config)
    await Initializer.getInstance().initialize(apiKey, context)
    sdkApiKey = apiKey
    sdkInitialized = true
  })()

  try {
    await sdkInitialization
  } finally {
    if (!sdkInitialized) {
      sdkInitialization = null
    }
  }
}

@Component
struct BaiduMapWrapper {
  @Prop apiKey: string
  @Prop @Watch('onPrivacyAgreedChanged') privacyAgreed: boolean = false
  @Prop oaidEnabled: boolean = false
  @Prop @Watch('onCenterPropChanged') center?: CenterPoint
  @Prop @Watch('onStoreMarkerChanged') storeMarker?: StoreMarkerOptions
  @Prop defaultMarkerIcon: string = 'rawfile://marker.png'
  @Prop zoom: number = 16
  @State inited: boolean = false
  onReady?: Function
  onCenterChange?: Function
  private controller?: MapController | null = null
  private onStatusChangeFinish?: (event: TMapViewEvent) => void
  private debounceTimer?: number
  private markerRequestId: number = 0
  private lastCenterLat: number = 39.914935
  private lastCenterLon: number = 116.403119
  private isProgrammaticCenterChange: boolean = false
  private storeMarkerOverlay?: Marker

  async aboutToAppear(): Promise<void> {
    await this.initializeMap()
  }

  aboutToDisappear(): void {
    this.markerRequestId += 1

    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
      this.debounceTimer = undefined
    }

    if (this.controller && this.onStatusChangeFinish) {
      this.controller.removeEventListener(MapEvent.MAPSTATUSCHANGEFINISH, this.onStatusChangeFinish)
      this.onStatusChangeFinish = undefined
    }

    if (this.controller && this.storeMarkerOverlay) {
      this.controller.removeOverlay(this.storeMarkerOverlay)
      this.storeMarkerOverlay = undefined
    }
  }

  private async initializeMap(): Promise<void> {
    if (this.inited) return

    try {
      const context = getContext() as common.UIAbilityContext
      await initializeSdk(this.apiKey, this.privacyAgreed, this.oaidEnabled, context)
      this.inited = true
    } catch (error) {
      const initializationError = new Error(String(error))
      console.warn('[uni-baidu-map-harmony] SDK initialization skipped or failed: ' + initializationError.message)
      this.emitReady(initializationError)
    }
  }

  private emitReady(error: Error | null): void {
    if (!this.onReady) return

    const event: MapReadyEvent = {
      detail: {
        err: error,
        controller: null,
      },
    }
    this.onReady(event)
  }

  onPrivacyAgreedChanged(): void {
    if (this.privacyAgreed && !this.inited) {
      void this.initializeMap()
    }
  }

  onCenterPropChanged(): void {
    if (!this.controller || !this.center) return

    if (this.lastCenterLat === this.center.lat && this.lastCenterLon === this.center.lon) {
      return
    }

    this.lastCenterLat = this.center.lat
    this.lastCenterLon = this.center.lon
    const point: LatLng = new LatLng(this.center.lat, this.center.lon)
    this.isProgrammaticCenterChange = true
    this.controller.setMapCenter(point)
  }

  onStoreMarkerChanged(): void {
    void this.updateStoreMarker()
  }

  private createStorePopView(markerData: StoreMarkerOptions): PopView {
    const popView = new PopView()
    const bubbleLayout = new VerticalLayout()
    bubbleLayout.setGravity(SysEnum.Gravity.GRAVITY_CENTER)

    const cardLayout = new VerticalLayout()
    cardLayout.setBackgroundColor(0xffffffff)
    cardLayout.setPadding(24, 16, 24, 16)

    if (markerData.name || markerData.distance) {
      const titleLayout = new HorizontalLayout()

      if (markerData.name) {
        const nameView = new LabelUI()
        nameView.setText(markerData.name)
        nameView.setWidth(BaseGroupUI.WRAP_CONTENT)
        nameView.setHeight(BaseGroupUI.WRAP_CONTENT)
        nameView.setMaxLines(1)
        nameView.setGravity(SysEnum.Gravity.GRAVITY_CENTER)
        const nameStyle = new TextStyle()
        nameStyle.setTextColor(0xff363636)
        nameStyle.setTextSize(28)
        nameView.setStyle(nameStyle)
        titleLayout.addView(nameView)
      }

      if (markerData.distance) {
        const distanceView = new LabelUI()
        distanceView.setText(markerData.distance)
        distanceView.setWidth(BaseGroupUI.WRAP_CONTENT)
        distanceView.setHeight(BaseGroupUI.WRAP_CONTENT)
        distanceView.setMaxLines(1)
        distanceView.setGravity(SysEnum.Gravity.GRAVITY_CENTER)
        distanceView.setMargin(12, 0, 0, 0)
        const distanceStyle = new TextStyle()
        distanceStyle.setTextColor(0xffe37931)
        distanceStyle.setTextSize(28)
        distanceView.setStyle(distanceStyle)
        titleLayout.addView(distanceView)
      }

      cardLayout.addView(titleLayout)
    }

    if (markerData.address) {
      const addressView = new LabelUI()
      addressView.setText(markerData.address)
      addressView.setWidth(BaseGroupUI.WRAP_CONTENT)
      addressView.setHeight(BaseGroupUI.WRAP_CONTENT)
      addressView.setMaxLines(1)
      addressView.setGravity(SysEnum.Gravity.GRAVITY_CENTER)
      addressView.setMargin(0, 4, 0, 0)
      const addressStyle = new TextStyle()
      addressStyle.setTextColor(0xff999999)
      addressStyle.setTextSize(24)
      addressView.setStyle(addressStyle)
      cardLayout.addView(addressView)
    }

    bubbleLayout.addView(cardLayout)

    const arrowView = new LabelUI()
    arrowView.setText('▼')
    arrowView.setWidth(BaseGroupUI.WRAP_CONTENT)
    arrowView.setHeight(BaseGroupUI.WRAP_CONTENT)
    arrowView.setGravity(SysEnum.Gravity.GRAVITY_CENTER)
    const arrowStyle = new TextStyle()
    arrowStyle.setTextColor(0xffffffff)
    arrowStyle.setTextSize(24)
    arrowView.setStyle(arrowStyle)
    bubbleLayout.addView(arrowView)

    popView.setView(bubbleLayout)
    popView.setLocated(SysEnum.Located.TOP)
    return popView
  }

  private async updateStoreMarker(): Promise<void> {
    const controller = this.controller
    if (!controller) return

    const requestId = ++this.markerRequestId
    const previousMarker = this.storeMarkerOverlay
    if (previousMarker) {
      controller.removeOverlay(previousMarker)
      this.storeMarkerOverlay = undefined
    }

    const markerData = this.storeMarker
    if (!markerData) return

    const iconSource = markerData.logo || this.defaultMarkerIcon
    if (!iconSource) {
      console.warn('[uni-baidu-map-harmony] A marker icon is required when storeMarker is provided.')
      return
    }

    const marker = new Marker({
      position: new LatLng(markerData.lat, markerData.lon),
      icon: new ImageEntity(iconSource, 80, 80),
      popView: markerData.name || markerData.distance || markerData.address
        ? this.createStorePopView(markerData)
        : undefined,
    })

    try {
      await controller.addOverlay(marker)
      if (requestId !== this.markerRequestId) {
        controller.removeOverlay(marker)
        return
      }
      this.storeMarkerOverlay = marker
    } catch (error) {
      console.error('[uni-baidu-map-harmony] Failed to add marker: ' + error)
    }
  }

  build(): void {
    if (!this.inited) return

    MapComponent({
      mapOptions: new MapOptions({
        shows: {
          satelliteMap: SysEnum.ESatelliteLayerType.NONE,
          trafficMap: false,
        },
      }),
      onReady: (err: Error | null, controller: MapController) => {
        if (err) {
          this.emitReady(err)
          return
        }

        try {
          if (!controller) {
            this.emitReady(new Error('Baidu Map returned an empty controller.'))
            return
          }

          this.controller = controller
          controller.setMapType(SysEnum.MapType.MAP_TYPE_NORMAL)
          controller.mapOptions.showMapPoi = true
          controller.mapOptions.showMapIndoorPoi = true

          const centerLat = this.center?.lat ?? 39.914935
          const centerLon = this.center?.lon ?? 116.403119
          this.lastCenterLat = centerLat
          this.lastCenterLon = centerLon
          const targetPoint: LatLng = new LatLng(centerLat, centerLon)
          this.isProgrammaticCenterChange = true
          controller.setMapCenter(targetPoint, this.zoom)
          void this.updateStoreMarker()

          const mapController = controller
          this.onStatusChangeFinish = (_event: TMapViewEvent) => {
            if (this.isProgrammaticCenterChange) {
              this.isProgrammaticCenterChange = false
              return
            }

            const center: LatLng = mapController.getCenter() as LatLng
            this.lastCenterLat = center.lat
            this.lastCenterLon = center.lng

            if (this.debounceTimer) {
              clearTimeout(this.debounceTimer)
            }

            this.debounceTimer = setTimeout(() => {
              this.debounceTimer = undefined
              if (this.onCenterChange) {
                const event: CenterChangeEvent = {
                  detail: {
                    lat: center.lat,
                    lon: center.lng,
                  },
                }
                this.onCenterChange(event)
              }
            }, 500)
          }
          controller.addEventListener(MapEvent.MAPSTATUSCHANGEFINISH, this.onStatusChangeFinish)
          this.emitReady(null)
        } catch (error) {
          this.emitReady(new Error(String(error)))
        }
      },
    })
      .width('100%')
      .height('100%')
  }
}

@Builder
function BaiduMapBuilder(options: BaiduMapBuilderOptions): void {
  BaiduMapWrapper({
    apiKey: options.apiKey,
    privacyAgreed: options.privacyAgreed,
    oaidEnabled: options.oaidEnabled,
    center: options.center,
    storeMarker: options.storeMarker,
    defaultMarkerIcon: options.defaultMarkerIcon,
    zoom: options.zoom,
    onReady: options.on?.get('ready'),
    onCenterChange: options.on?.get('centerchange'),
  })
    .width(options.width)
    .height(options.height)
}

defineNativeEmbed('baidu-map', { builder: BaiduMapBuilder })
