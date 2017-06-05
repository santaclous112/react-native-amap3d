package cn.qiuxiang.react.amap3d

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.annotations.ReactProp

@Suppress("unused")
internal class AMapPolylineManager : ViewGroupManager<AMapPolyline>() {
    override fun getName(): String {
        return "AMapPolyline"
    }

    override fun createViewInstance(reactContext: ThemedReactContext): AMapPolyline {
        return AMapPolyline(reactContext)
    }

    override fun getExportedCustomDirectEventTypeConstants(): Map<String, Any> {
        return mapOf("onPolylineClick" to mapOf("registrationName" to "onPolylineClick"))
    }

    @ReactProp(name = "coordinates")
    fun setCoordinate(polyline: AMapPolyline, coordinates: ReadableArray) {
        polyline.setCoordinates(coordinates)
    }

    @ReactProp(name = "colors")
    fun setColors(polyline: AMapPolyline, colors: ReadableArray) {
        polyline.setColors(colors)
    }

    @ReactProp(name = "color", customType = "Color")
    fun setColor(polyline: AMapPolyline, color: Int) {
        polyline.color = color
    }

    @ReactProp(name = "width")
    fun setWidth(polyline: AMapPolyline, width: Float) {
        polyline.width = width
    }

    @ReactProp(name = "zIndex")
    fun setZIndex_(polyline: AMapPolyline, zIndex: Float) {
        polyline.zIndex = zIndex
    }

    @ReactProp(name = "opacity")
    override fun setOpacity(polyline: AMapPolyline, opacity: Float) {
        polyline.opacity = opacity
    }

    @ReactProp(name = "geodesic")
    fun setGeodesic(polyline: AMapPolyline, geodesic: Boolean) {
        polyline.geodesic = geodesic
    }

    @ReactProp(name = "dottedLine")
    fun setDottedLine(polyline: AMapPolyline, dottedLine: Boolean) {
        polyline.dottedLine = dottedLine
    }

    @ReactProp(name = "gradient")
    fun setGradient(polyline: AMapPolyline, gradient: Boolean) {
        polyline.gradient = gradient
    }
}
