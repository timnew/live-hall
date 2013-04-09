#= require ../widgets/widget
#= require ../widgets/SideViewWidget
#= require ./QRCodeWidget
#= require ./RoomEditorPage

class @RoomPage extends Widget
  bindDom: ->
    @parts = {}
    @bindWidgetParts @parts
    @sideView = Widget.findWidgetByType('SideView')

  enhancePage: ->
    @room = @element.data('room')
    @bindActionHandlers()
    @bindStatusEventSource()

  initialize: ->
    @refresh()

  bindStatusEventSource: ->
    @statusSource = new EventSource("/view/#{@room.id}/status")

    @statusSource.addEventListener 'clientChanged', (e) =>
      @updateClientNumber e.data

    @statusSource.addEventListener 'launched', =>
      window.location.href= @parts.enterLink.attr('href')

  updateClientNumber: (number) ->
    @parts.clientCountDom.text number

  refresh: ->
    @parts.nameDom.text @room.name
    @parts.descriptionDom.text @room.description

  openPresenterView: ->
    @sideView.show().updateView('presenter')

class SharingBlock extends Widget
  bindDom: ->
    @bindWidgetParts()

  enhancePage: ->
    @zeroClipboard = new ZeroClipboard $("#copy-url"),
      hoverClass: "btn-primary:hover"
      activeClass: 'active'

  initialize: ->
    @shortenUrl @urlBox.val(), @updateUrl

  updateUrl: (url) =>
    if typeof(url) is 'string'
      @urlBox.val(url)
      @qrCode.update(url)
    else # in case of url is the gogole api response
      @updateUrl(url.id)

  shortenUrl: (url, callback) ->
    if url.match /^https?:\/\/goo.gl\/.*/
      return callback(url)

    postBody =
      longUrl: url

    $.postJson 'https://www.googleapis.com/urlshortener/v1/url', postBody, callback


class PresenterSharingBlock extends Widget
  bindDom: ->
    @bindWidgetParts()
    @noteSwitch = @element.find('.switch')

    @links = @element.data('links')

  enhancePage: ->
    @noteSwitch.on 'switch-change', (e, data) =>
      @enableNote(data.value)

  initialize: ->
    @enableNote(false)

  enableNote: (noteEnabled) ->
    key = if noteEnabled then 'note' else 'presenter'
    @updateLink @links[key]

  updateLink: (link) ->
    @hyperlink.attr 'href', link.localUrl
    @qrCode.update link.mobileUrl

class PresenterView extends Widget
  bindDom: ->
    @sideview = @findParentWidgetByType('SideView')

  enhancePage: ->
    @bindActionHandlers()

  openEditRoomView: ->
    @sideview.updateView('edit')

class EditRoomView extends Widget
  bindDom: ->
    @sideview = @findParentWidgetByType('SideView')
    @roomInfoForm = @findSubWidgetByType('RoomEditorPage.RoomInfoForm')

  enhancePage: ->
    @bindActionHandlers()

  updateRoom: ->
    @roomInfoForm.submit()

  cancel: ->
    @sideview.activateView('presenter')

RoomPage
  .createNamespace('RoomPage')
  .register(SharingBlock, 'SharingBlock')
  .register(PresenterView, 'PresenterView')
  .register(PresenterSharingBlock, 'PresenterSharingBlock')
  .register(EditRoomView, 'EditRoomView')
