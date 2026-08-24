<template>
  <view class="page">
    <!-- #ifdef APP-HARMONY -->
    <embed
      class="map"
      tag="baidu-map"
      :options="mapOptions"
      @ready="handleMapReady"
      @centerchange="handleCenterChange"
    />
    <button
      v-if="!mapOptions.privacyAgreed"
      class="consent-button"
      @tap="acceptPrivacyPolicy"
    >
      Demo: accept privacy policy
    </button>
    <!-- #endif -->
  </view>
</template>

<script setup>
import { ref } from 'vue'
import '@/uni_modules/uni-baidu-map-harmony'

const mapOptions = ref({
  apiKey: import.meta.env.VITE_BAIDU_MAP_HARMONY_KEY,
  privacyAgreed: false,
  oaidEnabled: false,
  center: {
    lat: 22.147624,
    lon: 113.580231,
  },
  zoom: 16,
  defaultMarkerIcon: 'rawfile://marker.png',
})

function handleMapReady(event) {
  if (event?.detail?.err) {
    console.error('Baidu Map is not ready:', event.detail.err)
  }
}

function handleCenterChange(event) {
  console.log('BD09 center:', event.detail)
}

function acceptPrivacyPolicy() {
  mapOptions.value = {
    ...mapOptions.value,
    privacyAgreed: true,
  }
}
</script>

<style>
.page,
.map {
  width: 100%;
  height: 100%;
}

.consent-button {
  position: absolute;
  left: 24rpx;
  right: 24rpx;
  bottom: 48rpx;
}
</style>
