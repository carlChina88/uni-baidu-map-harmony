import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const projectRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..')
const requireSdk = process.argv.includes('--require-sdk')

const requiredFiles = [
  'package.json',
  'README.md',
  'LICENSE',
  'NOTICE',
  'THIRD-PARTY-NOTICES.md',
  'utssdk/index.uts',
  'utssdk/app-harmony/index.uts',
  'utssdk/app-harmony/baidu-map-embed.ets',
  'utssdk/app-harmony/config.json',
]

const failures = []

for (const relativePath of requiredFiles) {
  const absolutePath = path.join(projectRoot, relativePath)
  if (!fs.existsSync(absolutePath)) {
    failures.push(`Missing required file: ${relativePath}`)
  }
}

const packagePath = path.join(projectRoot, 'package.json')
const configPath = path.join(projectRoot, 'utssdk/app-harmony/config.json')

if (fs.existsSync(packagePath)) {
  try {
    const packageJson = JSON.parse(fs.readFileSync(packagePath, 'utf8'))
    if (packageJson.name !== 'uni-baidu-map-harmony') {
      failures.push(`Unexpected package name: ${packageJson.name}`)
    }
    if (!packageJson.uni_modules?.platforms?.includes('app-harmony')) {
      failures.push('package.json must declare the app-harmony uni_modules platform')
    }
  } catch (error) {
    failures.push(`Invalid package.json: ${error.message}`)
  }
}

if (fs.existsSync(configPath)) {
  try {
    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'))
    const dependencyPath = config.dependencies?.['@bdmap/navi_map']
    if (dependencyPath !== './libs/navi_map-2.0.5.har') {
      failures.push(`Unexpected @bdmap/navi_map dependency path: ${dependencyPath}`)
    }
  } catch (error) {
    failures.push(`Invalid Harmony config.json: ${error.message}`)
  }
}

const embedPath = path.join(projectRoot, 'utssdk/app-harmony/baidu-map-embed.ets')
if (fs.existsSync(embedPath)) {
  const embedSource = fs.readFileSync(embedPath, 'utf8')
  const forbiddenPatterns = [
    { pattern: /bundleManager/, message: 'Do not require bundleManager for the map adapter.' },
    { pattern: /window\.|document\./, message: 'The Harmony native adapter must not use browser globals.' },
    { pattern: /console\.log\(/, message: 'Remove debug console.log calls before release.' },
  ]

  for (const { pattern, message } of forbiddenPatterns) {
    if (pattern.test(embedSource)) failures.push(message)
  }
}

const sdkPath = path.join(
  projectRoot,
  'utssdk/app-harmony/libs/navi_map-2.0.5.har',
)

if (!fs.existsSync(sdkPath)) {
  const message = 'Vendor HAR not found: utssdk/app-harmony/libs/navi_map-2.0.5.har'
  if (requireSdk) {
    failures.push(message)
  } else {
    console.warn(`Warning: ${message} (expected for this repository)`)
  }
} else {
  const size = fs.statSync(sdkPath).size
  if (size < 1024 * 1024) {
    failures.push(`Vendor HAR is unexpectedly small: ${size} bytes`)
  }
}

if (failures.length > 0) {
  console.error('Validation failed:')
  for (const failure of failures) console.error(`- ${failure}`)
  process.exitCode = 1
} else {
  console.log('Source validation passed.')
}
