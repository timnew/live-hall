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

  initialize: ->
    @refresh()

  refresh: ->
    @parts.nameDom.text @room.name
    @parts.descriptionDom.text @room.description
    @parts.clientCountDom.text @room.clientCount

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
    @shortenUrl();

  shortenUrl: ->
    return if @urlBox.data('shorten')

    postBody =
      longUrl: @urlBox.val()

    $.postJson 'https://www.googleapis.com/urlshortener/v1/url', postBody,
       (data) =>
         @urlBox.val(data.id)
         @qrCode.update(data.id)
         @urlBox.data('shorten', true)

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
    @sideview.activeView('presenter')


RoomPage
  .createNamespace()
  .register(SharingBlock, 'SharingBlock')
  .register(PresenterView, 'PresenterView')
  .register(EditRoomView, 'EditRoomView')
