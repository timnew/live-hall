#= require ../widgets/widget
#= require ../widgets/EventSourceWidget
#= require ../widgets/SideViewWidget
#= require ../widgets/QRCodeWidget
#= require ./RoomEditorPage

shortenUrl = (url, callback) ->
  if url.match /^https?:\/\/goo.gl\/.*/
    return callback(url)

  postBody =
    longUrl: url

  $.postJson 'https://www.googleapis.com/urlshortener/v1/url', postBody, callback

class @RoomPage extends EventSourceWidget
  bindDom: ->
    @parts = {}
    @bindWidgetParts @parts
    @sideView = Widget.findWidgetByType('SideView')

  enhancePage: ->
    @room = @element.data('room')
    @bindActionHandlers()
    @initEventSource("/view/#{@room.id}/events")
    @hookEvents()

  initialize: ->
    @refresh()

  refreshHook: ->
    window.location.reload(true)

  updateViewHook: (viewName) =>
    @sideView.updateView(viewName)

  clientChangedHook: (count) =>
    @updateClientNumber count

  launchedHook: =>
    window.location.href = @parts.enterLink.attr('href')

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
    shortenUrl @urlBox.val(), @updateUrl

  updateUrl: (url) =>
    if typeof(url) is 'string'
      @urlBox.val(url)
      @qrCode.update(url)
    else # in case of url is the gogole api response
      @updateUrl(url.id)

class PresenterSharingBlock extends Widget
  bindDom: ->
    @bindWidgetParts()
    @noteSwitch = @element.find('.switch')

    @links = @element.data('links')
    @auth = @element.data('auth')

  enhancePage: ->
    @noteSwitch.on 'switch-change', (e, data) =>
      @enableNote(data.value)

  initialize: ->
    @enableNote(false)
    @shortenUrl()

  shortenUrl: ->
    shortenUrl @links.note.launchUrl, (data) =>
      @links.note.launchUrl = data.id
      @refreshLink()

    shortenUrl @links.presenter.launchUrl, (data) =>
      @links.presenter.launchUrl = data.id
      @refreshLink()

  enableNote: (noteEnabled) ->
    key = if noteEnabled then 'note' else 'presenter'
    @updateLink @links[key]

  refreshLink: ->
    @enableNote @noteSwitch.switch('status')

  updateLink: (link) ->
    @viewLink?.attr 'href', link.viewUrl
    @launchLink?.attr 'href', link.launchUrl
    authLink = if @auth? then @auth + link.launchUrl else link.launchUrl
    @qrCode.update authLink

class PresenterView extends Widget
  bindDom: ->
    @sideview = @findParentWidgetByType('SideView')

  enhancePage: ->
    @bindActionHandlers()

  openEditRoomView: ->
    @sideview.updateView('edit')

  openLockRoomView: ->
    @sideview.updateView('lock-down')


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

class TiQrView extends Widget
  bindDom: ->
    @sideview = @findParentWidgetByType('SideView')

  enhancePage: ->
    @bindActionHandlers()

  back: ->
    @sideview.activateView('presenter')

RoomPage
  .createNamespace('RoomPage')
  .register(SharingBlock, 'SharingBlock')
  .register(PresenterView, 'PresenterView')
  .register(PresenterSharingBlock, 'PresenterSharingBlock')
  .register(EditRoomView, 'EditRoomView')
  .register(TiQrView, 'TiQrView')
