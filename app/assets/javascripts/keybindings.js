(function() {
  var handleKeyBindings;

  $(function() {
    return handleKeyBindings();
  });

  $(document).on('page:change', function() {
    return handleKeyBindings();
  });

  handleKeyBindings = function() {
    Mousetrap.reset();
    $('a[data-keybinding]').each(function(i, el) {
      var bindedKey;
      bindedKey = $(el).data('keybinding');
      if (typeof bindedKey === 'number') {
        bindedKey = bindedKey.toString();
      }
      return Mousetrap.bind(bindedKey, function(e) {
        if (typeof Turbolinks === 'undefined') {
          return el.click();
        } else {
          return Turbolinks.visit(el.href);
        }
      });
    });
    $('input[data-keybinding]').each(function(i, el) {
      return Mousetrap.bind($(el).data('keybinding'), function(e) {
        el.focus();
        if (e.preventDefault) {
          return e.preventDefault();
        } else {
          return e.returnValue = false;
        }
      });
    });
    window.mouseTrapRails = {
      showOnLoad: false,
      toggleKeys: 'alt+shift+h',
      keysShown: false,
      toggleHints: function() {
        $('a[data-keybinding]').each(function(i, el) {
          var $el, $hint, mtKey;
          $el = $(el);
          if (mouseTrapRails.keysShown) {
            return $el.removeClass('mt-hotkey-el').find('.mt-hotkey-hint').remove();
          } else {
            mtKey = $el.data('keybinding');
            $hint = "<i class='mt-hotkey-hint' title='Press \<" + mtKey + "\> to open link'>" + mtKey + "</i>";
            if ($el.css('position') !== 'absolute') {
              $el.addClass('mt-hotkey-el');
            }
            return $el.append($hint);
          }
        });
        return this.keysShown ^= true;
      }
    };
    Mousetrap.bind(mouseTrapRails.toggleKeys, function() {
      return mouseTrapRails.toggleHints();
    });
    if (mouseTrapRails.showOnLoad) {
      return mouseTrapRails.toggleHints();
    }
  };

}).call(this);