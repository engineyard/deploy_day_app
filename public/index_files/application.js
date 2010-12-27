function initialize() {
  // logger
  window.log = function(){
    log.history = log.history || [];
    log.history.push(arguments);
    window.console && console.log[console.firebug ? 'apply' : 'call'](console, Array.prototype.slice.call(arguments));
  }
  
  window.logargs = function(context){
    log(context,arguments.callee.caller.arguments); 
  }

  application = {
    authenticity_token: $('meta[name=csrf-token]').attr('content')
  }
  
  // prep headers for ajax
  $.ajaxSetup({
    'beforeSend' : function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
  });
  
}


// load bio for contributor
$.fn.load_bio = function(options) {  
  $("#contributors_page .person_thumb").live("click", function(event) {
    $(this).removeClass("active");
    $(this).addClass("loading");
    $(this).prepend("<span class='bio_loader'></span>");
    $.getScript(this.href);
    event.preventDefault();
  });
};

// load bio from links to contributor
$.fn.linked_bio = function(options) {  
  console.log(this)
};

// load more... pagination
$.fn.load_more = function(options) {  
  $("#load_more").live("click", function(event) {
    $(this).addClass("loading")
    $("#load_more span").html("Loading...")
    $.getScript(this.href);
    event.preventDefault();
  });
};

// New Gold Leaf Form Helper Text Plugin for jQuery $('input').helper('inactive_class')
(function($){
$.fn.helper = function(helperText) {
  return this.each(function() {
    
    var tag = this.tagName
    
    if (jQuery(this).val() != "") {
      jQuery(this).next().hide();
    }
    
    jQuery(this).next().click(function () {
      jQuery(this).prev(tag).focus();
      jQuery(this).hide();
    });
    
    jQuery(this).focus(function () {
      jQuery(this).next().hide();
    });
    
    jQuery(this).blur(function () {
      if (jQuery(this).val() == "") {
        jQuery(this).next().fadeIn("fast");
      };
    });
    
  });
};
})(jQuery);

(function($){
$.fn.confirmWith = function(message) {
  return this.each(function() {
    
    $(this).hide();
    
    var original_message = $(this).html()
    var confirmation_message = message
    
    var button = document.createElement('a');
    var span = document.createElement('span');

    $(button).addClass("simple_button");
    $(button).html(original_message);
    
    $(button).prependTo($(this).parent())
    
    var confirmation_button = this
    
    $(button).bind("click", function() {
      $(button).hide();
      $(confirmation_button).addClass("warning").html("<span>" + confirmation_message + "</span>").show();
    });
  });
};
})(jQuery);

(function($){
$.fn.confirmRemoteDestroy = function(message) {
  return this.each(function() {
    $(this).fadeOut('fast', function() {
      $(this).remove();
    });
  });
};
})(jQuery);

(function($){
$.fn.captionCodeBlocks = function(attr) {
  return this.each(function() {
    jQuery(this).prepend("<h5>" + jQuery(this).attr("caption") + "</h5>")
  });
};
})(jQuery);

var cookie;

/* NGL notification helpers. depends on jQuery.cookie plugin */
(function($){
  if (typeof(jQuery.cookie) != 'function') {
    $.fn.notifications = function(){};
    return false;
  };
  var defaults = {cookie : 'notifications', notice_selector : 'div.alert', notice_prefix : 'alert_', id_attr : 'data-notice-id'}
  
  $.fn.notifications = function(options){
    options = $.extend({}, defaults, options);

    this.each(function(el){
      var el = $(this);
      
      el.click(function(){
        var id = $(this).attr(options['id_attr']);
        var notice = ["#", options['notice_prefix'], id].join('')
        cookie = $.cookie(options['cookie']);
        seen = cookie==null ? [] : cookie;
        seen.push(id);
        $.cookie(options['cookie'], seen.join(' '), {expires : 90})
        $(notice).fadeOut('fast');
      });
    });
  };
})(jQuery);

(function($){
  $.fn.delaySlideUp = function(){
    this.each(function(){
      $(this).delay(2000).slideUp(function(){$(this).remove()});
    });
    return this;
  };
})(jQuery);

$(document).ready(function () {
  
  $('#Email').keypress(function(event) {
    if (event.keyCode == '13') {
      formSubmit(document.getElementById("mktForm_1002"));
      this.blur();
      return false;
    } else {
      return true;
    }
  });
  
  if (window.location.pathname.match(/contributors/)) {
    contributor_id = window.location.hash.substr(1)
    $("a[href=/contributors/" + contributor_id + "]").addClass("loading")
    $.getScript("/contributors/" + contributor_id);
  }
  
  // confirm delete buttons
  $("a[data-method='delete'][data-remote='true']").confirmWith("Are you sure?");
  
  $('.mktFormEmail').helper('inactive_class');
  
  // tipsy tool tips
  $('[rel=tipsy]').tipsy({gravity: 's'});

  $("a.close_alert").notifications();
  
  // load bio
  // $(".person_thumb").load_bio();
  
  // load more style pagination
  $("#load_more").load_more();

  // prevent users from clicking active tabs
  $(".active a, li.current a").click(function(event) {
    event.preventDefault();
  });
  
  $("div[caption]").captionCodeBlocks("caption")
  
  // pretty forms!
  if(jQuery().uniform) $(".uniform input, .uniform textarea, .uniform select").uniform();

  // ============================
  // = add/remove form elements =
  // ============================   
  $('.add_child').click(function() {
    var association = $(this).attr('data-association');
    var template = $('#' + association + '_fields_template').html();
    var regexp = new RegExp('new_' + association, 'g');
    var new_id = new Date().getTime();

    console.log(association, template, regexp, new_id);

    $(this).parent().before(template.replace(regexp, new_id));
    return false;
  });

  $('.remove_child').live('click', function() {
    var hidden_field = $(this).prev('input[type=hidden]')[0];
    if(hidden_field) {
      hidden_field.value = '1';
    }
    $(this).parents('.fields').hide();
    return false;
  });
  
  $('.focus').focus();

  

});