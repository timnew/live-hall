/*
    jQuery Json Ajax extension
    Copyright (c) TimNew 2013
    Released under MIT license
 */
(function($){
    function createAjaxMethod(method) {
        method = method.toUpperCase();
        return function(url, data, callback, contentType) {
            if(typeof(data)==='function') {
                contentType = callback;
                callback = data;
                data = {};
            }

            if (contentType == null) {
                contentType = "application/json";
            }

            return jQuery.ajax({
                type: method,
                url: url,
                data: JSON.stringify(data),
                success: callback,
                dataType: "json",
                contentType: contentType,
                processData: false
            });
        };
    }

    $.extend({
        postJson: createAjaxMethod('post'),
        putJson: createAjaxMethod('put')
    });

    function serializeJson() {
        var result = {};

        $.each(this.serializeArray(), function(i, item){
            result[item.name] = item.value;
        });

        return result;
    }

    $.fn.extend({
        serializeJson: serializeJson
    });
})(window.jQuery);

