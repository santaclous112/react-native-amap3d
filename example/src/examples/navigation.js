import React, {Component} from 'react'
import {StyleSheet} from 'react-native'
import {Navigation} from 'react-native-amap3d'

export default class NavigationExample extends Component {
  static navigationOptions = {
    title: '导航',
  }

  _ready = () => {
    this._navigation.calculateDriveRoute(
      {
        latitude: 39.906901,
        longitude: 116.397972,
      },
      {
        latitude: 39.806901,
        longitude: 116.397972,
      }
    )
  }

  _start = () => this._navigation.start()

  render() {
    return <Navigation
      ref={ref => this._navigation = ref}
      style={StyleSheet.absoluteFill}
      onReady={this._ready}
      onCalculateRouteSuccess={this._start}
    />
  }
}
