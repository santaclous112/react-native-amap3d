// @flow
import React from 'react'
import PropTypes from 'prop-types'
import {ViewPropTypes} from 'react-native'
import {LatLng} from '../PropTypes'
import BaseComponent from '../BaseComponent'

export default class Base extends BaseComponent<any> {
  static propTypes = {
    ...ViewPropTypes,

    /**
     * 路径规划成功事件
     */
    onCalculateRouteSuccess: PropTypes.func,

    /**
     * 路径规划失败事件
     */
    onCalculateRouteFailure: PropTypes.func,
  }

  /**
   * 路线规划
   */
  calculateRoute(start: LatLng, end: LatLng, way: LatLng[] = []) {
    this._sendCommand('calculateRoute', [start, end, way])
  }

  /**
   * 开始导航
   */
  start() {
    this._sendCommand('start')
  }
}
