//     DarkroomJS

//     (c) 2013 Matthieu Moquet.
//     DarkroomJS may be freely distributed under the MIT license.
//     For all details and documentation:
//     http://mattketmo.github.io/darkroomjs

;(function(window, document, fabric) {
  'use strict';

  // Utilities
  // ---------

  // Utility method to easily extend objects.
  function extend(b, a) {
    var prop;
    if (b === undefined) {
      return a;
    }
    for (prop in a) {
      if (a.hasOwnProperty(prop) && b.hasOwnProperty(prop) === false) {
        b[prop] = a[prop];
      }
    }
    return b;
  }

  // Root definitions
  // ----------------

  // Core object of DarkroomJS.
  // Basically it's a single object, instanciable via an element
  // (it could be a CSS selector or a DOM element), some custom options,
  // and a list of plugin objects (or none to use default ones).
  function Darkroom(element, options, plugins) {
    return this.init(element, options, plugins);
  }

  // Darkroom namespace is the only one available outside of this context.
  window.Darkroom = Darkroom;

  // Create an empty list of plugin objects, which will be filled by
  // other plugin scripts. This is the default plugin list if none is
  // specified in Darkroom'ss constructor.
  Darkroom.plugins = [];

  // Define a plugin object. This is the (abstract) parent class which
  // has to be extended for each plugin.
  function Plugin(darkroom, options) {
    this.darkroom = darkroom;
    this.options = extend(options, this.defaults);
    this.initialize();
  }

  Plugin.prototype = {
    defaults: {},
    initialize: function() { }
  }

  // Inspired by Backbone.js extend capability.
  Plugin.extend = function(protoProps) {
    var parent = this;
    var child;

    if (protoProps && protoProps.hasOwnProperty('constructor')) {
      child = protoProps.constructor;
    } else {
      child = function(){ return parent.apply(this, arguments); };
    }

    extend(child, parent);

    var Surrogate = function(){ this.constructor = child; };
    Surrogate.prototype = parent.prototype;
    child.prototype = new Surrogate;

    if (protoProps) extend(child.prototype, protoProps);

    child.__super__ = parent.prototype;

    return child;
  }

  // Attach the plugin class into the main namespace.
  Darkroom.Plugin = Plugin;

  // UI elements
  // -----------

  // Toolbar object.
  function Toolbar(element) {
    this.element = element;
    this.actionsElement = element.querySelector('.darkroom-toolbar-actions');
  }

  Toolbar.prototype.createButtonGroup = function(options) {
    var buttonGroup = document.createElement('li');
    buttonGroup.className = 'darkroom-button-group';
    /*buttonGroup.innerHTML = '<ul></ul>';*/
    this.actionsElement.appendChild(buttonGroup);

    return new ButtonGroup(buttonGroup);
  };

  // ButtonGroup object.
  function ButtonGroup(element) {
    this.element = element;
  }

  ButtonGroup.prototype.createButton = function(options) {
    var defaults = {
      image: 'help',
      type: 'default',
      group: 'default',
      hide: false,
      disabled: false
    };

    options = extend(options, defaults);

    var button = document.createElement('button');
    button.className = 'darkroom-button darkroom-button-' + options.type;
    button.innerHTML = '<i class="darkroom-icon-' + options.image + '"></i>';
    this.element.appendChild(button);

    var button = new Button(button);
    button.hide(options.hide);
    button.disable(options.disabled);

    return button;
  }

  // Button object.
  function Button(element) {
    this.element = element;
  }
  Button.prototype = {
    addEventListener: function(eventName, callback) {
      var el = this.element;
      if (el.addEventListener){
        el.addEventListener(eventName, callback);
      } else if (el.attachEvent) {
        el.attachEvent('on' + eventName, callback);
      }
    },
    active: function(value) {
      if (value)
        this.element.classList.add('darkroom-button-active');
      else
        this.element.classList.remove('darkroom-button-active');
    },
    hide: function(value) {
      if (value)
        this.element.classList.add('darkroom-button-hidden');
      else
        this.element.classList.remove('darkroom-button-hidden');
    },
    disable: function(value) {
      this.element.disabled = (value) ? true : false;
    }
  };

  // Extend the default fabric canvas object to add default options.
  var Canvas = fabric.util.createClass(fabric.Canvas, {
  });

  // Core object prototype
  // ---------------------

  Darkroom.prototype = {
    // This is the default options.
    // It has it's own options, such as dimension specification (min/max
    // width and height), plus options for each plugins.
    // Option for those plugins are passed through plugin name.
    // `init` option is a callback called after image is loaded into the
    // canvas.
    defaults: {
      // main options
      minWidth: null,
      minHeight: null,
      maxWidth: null,
      maxHeight: null,
      backgroundColor: '#ccc',

      // plugins options
      plugins: {},

      // after initialisation callback
      init: function() {}
    },

    // Add ability to attach event listener on the core object.
    // It uses the canvas element to process events.
    addEventListener: function(eventName, callback) {
      var el = this.canvas.getElement();
      if (el.addEventListener){
        el.addEventListener(eventName, callback);
      } else if (el.attachEvent) {
        el.attachEvent('on' + eventName, callback);
      }
    },
    dispatchEvent: function(eventName) {
      // Use the old way of creating event to be IE compatible
      // See https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Creating_and_triggering_events
      var event = document.createEvent('Event');
      event.initEvent(eventName, true, true);

      this.canvas.getElement().dispatchEvent(event);
    },

    // Initialisation.
    // It will replace the given image element by a canvas plus some wrapper
    // `div` blocks. A toolbar object is instanciated and the image is loaded
    // into the canvas element. Finally it calls each plugins initialisation
    // methods.
    init: function(element, options, plugins) {
      var _this = this;
      this.options = extend(options, this.defaults);

      if (typeof element === 'string')
        element = document.querySelector(element);
      if (null === element)
        return;

      var plugins = plugins || Darkroom.plugins;

      var image = new Image();

      image.onload = function() {
        _this
          .createFabricImage(element)
          .initDOM(element)
          .initPlugins(plugins)
        ;

        // Execute a custom callback after initialization
        _this.options.init.bind(_this).call();
      }

      /*image.crossOrigin = 'anonymous';*/
      image.src = element.src;
    },

    initDOM: function(element) {
      // Create toolbar element
      var toolbar = document.createElement('div');
      toolbar.className = 'darkroom-toolbar';
      toolbar.innerHTML = '<ul class="darkroom-toolbar-actions"></ul>';

      // Create canvas element
      var canvas = document.createElement('canvas');
      var canvasContainer = document.createElement('div');
      canvasContainer.className = 'darkroom-image-container';
      canvasContainer.appendChild(canvas);

      // Create container element
      this.container = document.createElement('div');
      this.container.className = 'darkroom-container';

      // Assemble elements
      this.container.appendChild(toolbar);
      this.container.appendChild(canvasContainer);

      // Replace image with new DOM
      element.parentNode.replaceChild(this.container, element);

      // Save elements
      this.toolbar = new Toolbar(toolbar);
      this.canvas = new Canvas(canvas, {
        selection: false,
        backgroundColor: this.options.backgroundColor
      });

      this.canvas.setWidth(this.image.getWidth());
      this.canvas.setHeight(this.image.getHeight());
      this.canvas.add(this.image);
      this.canvas.centerObject(this.image);
      this.image.setCoords();

      return this;
    },

    createFabricImage: function(imgElement) {
      var width = imgElement.width;
      var height = imgElement.height;
      var scaleMin = 1;
      var scaleMax = 1;
      var scaleX = 1;
      var scaleY = 1;

      if (null !== this.options.maxWidth && this.options.maxWidth < width) {
        scaleX =  this.options.maxWidth / width;
      }
      if (null !== this.options.maxHeight && this.options.maxHeight < height) {
        scaleY =  this.options.maxHeight / height;
      }
      scaleMin = Math.min(scaleX, scaleY);

      scaleX = 1;
      scaleY = 1;
      if (null !== this.options.minWidth && this.options.minWidth > width) {
        scaleX =  this.options.minWidth / width;
      }
      if (null !== this.options.minHeight && this.options.minHeight > height) {
        scaleY =  this.options.minHeight / height;
      }
      scaleMax = Math.max(scaleX, scaleY);

      var scale = scaleMax * scaleMin; // one should be equals to 1

      width *= scale;
      height *= scale;

      this.image = new fabric.Image(imgElement, {
        // options to make the image static
        selectable: false,
        evented: false,
        lockMovementX: true,
        lockMovementY: true,
        lockRotation: true,
        lockScalingX: true,
        lockScalingY: true,
        lockUniScaling: true,
        hasControls: false,
        hasBorders: false
      });
      this.image.setScaleX(scale);
      this.image.setScaleY(scale);

      return this;
    },

    initPlugins: function(plugins) {
      this.plugins = {};

      for (var name in plugins) {
        var plugin = plugins[name];
        var options = this.options.plugins[name];

        // Setting false into the plugin options will disable the plugin
        if (options === false) {
          continue;
        }
        if (!plugins.hasOwnProperty(name)) continue;
        this.plugins[name] = new plugin(this, options);
      }
    },

    getPlugin: function(name) {
      return this.plugins[name];
    },

    selfDestroy: function() {
      var container = this.container;

      var image = new Image();
      image.onload = function() {
        container.parentNode.replaceChild(image, container);
      }

      image.src = this.snapshotImage();

      /* TODO
       - destroy plugins
       - delete canvas
      */
    },

    snapshotImage: function() {
      return this.image.toDataURL();
    }

  };

})(window, window.document, fabric);

;(function(window, document, Darkroom, fabric) {
  'use strict';

  Darkroom.plugins['history'] = Darkroom.Plugin.extend({
    initialize: function InitDarkroomHistoryPlugin() {
      this._initButtons();

      this.backHistoryStack = [];
      this.forwardHistoryStack = [];

      this._snapshotImage();

      this.darkroom.addEventListener('image:change', this._onImageChange.bind(this));
    },

    goBack: function() {
      if (this.backHistoryStack.length === 0) {
        return;
      }

      this.forwardHistoryStack.push(this.currentImage);
      this.currentImage = this.backHistoryStack.pop();
      this._applyImage(this.currentImage);
      this._updateButtons();

      // Dispatch an event, so listeners will know the 
      // currently viewed image has been changed.
      this.darkroom.dispatchEvent('history:navigate');
    },

    goForward: function() {
      if (this.forwardHistoryStack.length === 0) {
        return;
      }

      this.backHistoryStack.push(this.currentImage);
      this.currentImage = this.forwardHistoryStack.pop();
      this._applyImage(this.currentImage);
      this._updateButtons();

      // Dispatch an event, so listeners will know the 
      // currently viewed image has been changed.
      this.darkroom.dispatchEvent('history:navigate');
    },

    _initButtons: function() {
      var buttonGroup = this.darkroom.toolbar.createButtonGroup();

      this.backButton = buttonGroup.createButton({
        image: 'back',
        disabled: true
      });

      this.forwardButton = buttonGroup.createButton({
        image: 'forward',
        disabled: true
      });

      this.backButton.addEventListener('click', this.goBack.bind(this));
      this.forwardButton.addEventListener('click', this.goForward.bind(this));

      return this;
    },

    _updateButtons: function() {
      this.backButton.disable((this.backHistoryStack.length === 0))
      this.forwardButton.disable((this.forwardHistoryStack.length === 0))
    },

    _snapshotImage: function() {
      var _this = this;
      var image = new Image();
      image.src = this.darkroom.snapshotImage();

      this.currentImage = image;
    },

    _onImageChange: function() {
      this.backHistoryStack.push(this.currentImage);
      this._snapshotImage();
      this.forwardHistoryStack.length = 0;
      this._updateButtons();
    },

    // Apply image to the canvas
    _applyImage: function(image) {
      var canvas = this.darkroom.canvas;

      var imgInstance = new fabric.Image(image, {
        // options to make the image static
        selectable: false,
        evented: false,
        lockMovementX: true,
        lockMovementY: true,
        lockRotation: true,
        lockScalingX: true,
        lockScalingY: true,
        lockUniScaling: true,
        hasControls: false,
        hasBorders: false
      });

      // Update canvas size
      canvas.setWidth(image.width);
      canvas.setHeight(image.height);

      // Add image
      this.darkroom.image.remove();
      this.darkroom.image = imgInstance;
      canvas.add(imgInstance);
    }
  });
})(window, document, Darkroom, fabric);

;(function(window, document, Darkroom, fabric) {
  'use strict';

  Darkroom.plugins['rotate'] = Darkroom.Plugin.extend({
    initialize: function InitDarkroomRotatePlugin() {
      var buttonGroup = this.darkroom.toolbar.createButtonGroup();

      this.leftButton = buttonGroup.createButton({
        image: 'rotate-left'
      });

      this.rightButton = buttonGroup.createButton({
        image: 'rotate-right'
      });

      this.leftButton.addEventListener('click', this.rotateLeft.bind(this));
      this.rightButton.addEventListener('click', this.rotateRight.bind(this));
    },

    rotateLeft: function rotateLeft() {
      this.rotate(-90);
    },

    rotateRight: function rotateRight() {
      this.rotate(90);
    },

    rotate: function rotate(angle) {
      var _this = this;

      var darkroom = this.darkroom;
      var canvas = darkroom.canvas;
      var image = darkroom.image;
      angle = (image.getAngle() + angle) % 360;

      var width, height;
      height = Math.abs(image.getWidth()*(Math.sin(angle*Math.PI/180)))+Math.abs(image.getHeight()*(Math.cos(angle*Math.PI/180)));
      width = Math.abs(image.getHeight()*(Math.sin(angle*Math.PI/180)))+Math.abs(image.getWidth()*(Math.cos(angle*Math.PI/180)));

      canvas.setWidth(width);
      canvas.setHeight(height);

      image.rotate(angle);

      canvas.centerObject(image);
      image.setCoords();

      canvas.renderAll();

      darkroom.dispatchEvent('image:change');
    }
  });
})(window, document, Darkroom, fabric);

;(function(window, document, Darkroom, fabric) {
  'use strict';

  var CropZone = fabric.util.createClass(fabric.Rect, {
    _render: function(ctx) {
      this.callSuper('_render', ctx);

      var canvas = ctx.canvas;
      var dashWidth = 7;

      // Set original scale
      var flipX = this.flipX ? -1 : 1;
      var flipY = this.flipY ? -1 : 1;
      var scaleX = flipX / this.scaleX;
      var scaleY = flipY / this.scaleY;

      ctx.scale(scaleX, scaleY);

      // Overlay rendering
      ctx.fillStyle = 'rgba(0, 0, 0, 0.5)';
      this._renderOverlay(ctx);

      // Set dashed borders
      if (ctx.setLineDash !== undefined)
        ctx.setLineDash([dashWidth, dashWidth]);
      else if (ctx.mozDash !== undefined)
        ctx.mozDash = [dashWidth, dashWidth];

      // First lines rendering with black
      ctx.strokeStyle = 'rgba(0, 0, 0, 0.2)';
      this._renderBorders(ctx);
      this._renderGrid(ctx);

      // Re render lines in white
      ctx.lineDashOffset = dashWidth;
      ctx.strokeStyle = 'rgba(255, 255, 255, 0.4)';
      this._renderBorders(ctx);
      this._renderGrid(ctx);

      // Reset scale
      ctx.scale(1/scaleX, 1/scaleY);
    },

    _renderOverlay: function(ctx) {
      var canvas = ctx.canvas;
      var borderOffset = 0;

      //
      //    x0    x1        x2      x3
      // y0 +------------------------+
      //    |\\\\\\\\\\\\\\\\\\\\\\\\|
      //    |\\\\\\\\\\\\\\\\\\\\\\\\|
      // y1 +------+---------+-------+
      //    |\\\\\\|         |\\\\\\\|
      //    |\\\\\\|    0    |\\\\\\\|
      //    |\\\\\\|         |\\\\\\\|
      // y2 +------+---------+-------+
      //    |\\\\\\\\\\\\\\\\\\\\\\\\|
      //    |\\\\\\\\\\\\\\\\\\\\\\\\|
      // y3 +------------------------+
      //

      var x0 = Math.ceil(-this.getWidth() / 2 - this.getLeft());
      var x1 = Math.ceil(-this.getWidth() / 2);
      var x2 = Math.ceil(this.getWidth() / 2);
      var x3 = Math.ceil(this.getWidth() / 2 + (canvas.width - this.getWidth() - this.getLeft()));

      var y0 = Math.ceil(-this.getHeight() / 2 - this.getTop());
      var y1 = Math.ceil(-this.getHeight() / 2);
      var y2 = Math.ceil(this.getHeight() / 2);
      var y3 = Math.ceil(this.getHeight() / 2 + (canvas.height - this.getHeight() - this.getTop()));

      // Upper rect
      ctx.fillRect(x0, y0, x3 - x0, y1 - y0 + borderOffset);

      // Left rect
      ctx.fillRect(x0, y1, x1 - x0, y2 - y1 + borderOffset);

      // Right rect
      ctx.fillRect(x2, y1, x3 - x2, y2 - y1 + borderOffset);

      // Down rect
      ctx.fillRect(x0, y2, x3 - x0, y3 - y2);
    },

    _renderBorders: function(ctx) {
      ctx.beginPath();
      ctx.moveTo(-this.getWidth()/2, -this.getHeight()/2); // upper left
      ctx.lineTo(this.getWidth()/2, -this.getHeight()/2); // upper right
      ctx.lineTo(this.getWidth()/2, this.getHeight()/2); // down right
      ctx.lineTo(-this.getWidth()/2, this.getHeight()/2); // down left
      ctx.lineTo(-this.getWidth()/2, -this.getHeight()/2); // upper left
      ctx.stroke();
    },

    _renderGrid: function(ctx) {
      // Vertical lines
      ctx.beginPath();
      ctx.moveTo(-this.getWidth()/2 + 1/3 * this.getWidth(), -this.getHeight()/2);
      ctx.lineTo(-this.getWidth()/2 + 1/3 * this.getWidth(), this.getHeight()/2);
      ctx.stroke();
      ctx.beginPath();
      ctx.moveTo(-this.getWidth()/2 + 2/3 * this.getWidth(), -this.getHeight()/2);
      ctx.lineTo(-this.getWidth()/2 + 2/3 * this.getWidth(), this.getHeight()/2);
      ctx.stroke();
      // Horizontal lines
      ctx.beginPath();
      ctx.moveTo(-this.getWidth()/2, -this.getHeight()/2 + 1/3 * this.getHeight());
      ctx.lineTo(this.getWidth()/2, -this.getHeight()/2 + 1/3 * this.getHeight());
      ctx.stroke();
      ctx.beginPath();
      ctx.moveTo(-this.getWidth()/2, -this.getHeight()/2 + 2/3 * this.getHeight());
      ctx.lineTo(this.getWidth()/2, -this.getHeight()/2 + 2/3 * this.getHeight());
      ctx.stroke();
    }
  });

  Darkroom.plugins['crop'] = Darkroom.Plugin.extend({
    // Init point
    startX: null,
    startY: null,

    // Keycrop
    isKeyCroping: false,
    isKeyLeft: false,
    isKeyUp: false,

    defaults: {
      // min crop dimension
      minHeight: 1,
      minWidth: 1,
      // ensure crop ratio
      ratio: null,
      // quick crop feature (set a key code to enable it)
      quickCropKey: false
    },

    initialize: function InitDarkroomCropPlugin() {
      var buttonGroup = this.darkroom.toolbar.createButtonGroup();

      this.cropButton = buttonGroup.createButton({
        image: 'crop'
      });
      this.okButton = buttonGroup.createButton({
        image: 'accept',
        type: 'success',
        hide: true
      });
      this.cancelButton = buttonGroup.createButton({
        image: 'cancel',
        type: 'danger',
        hide: true
      });

      // Buttons click
      this.cropButton.addEventListener('click', this.toggleCrop.bind(this));
      this.okButton.addEventListener('click', this.cropCurrentZone.bind(this));
      this.cancelButton.addEventListener('click', this.releaseFocus.bind(this));

      // Canvas events
      this.darkroom.canvas.on('mouse:down', this.onMouseDown.bind(this));
      this.darkroom.canvas.on('mouse:move', this.onMouseMove.bind(this));
      this.darkroom.canvas.on('mouse:up', this.onMouseUp.bind(this));
      this.darkroom.canvas.on('object:moving', this.onObjectMoving.bind(this));
      this.darkroom.canvas.on('object:scaling', this.onObjectScaling.bind(this));

      fabric.util.addListener(fabric.document, 'keydown', this.onKeyDown.bind(this));
      fabric.util.addListener(fabric.document, 'keyup', this.onKeyUp.bind(this));

      this.darkroom.addEventListener('image:change', this.releaseFocus.bind(this));
    },

    // Avoid crop zone to go beyond the canvas edges
    onObjectMoving: function(event) {
      if (!this.hasFocus()) {
        return;
      }

      var currentObject = event.target;
      if (currentObject !== this.cropZone)
        return;

      var canvas = this.darkroom.canvas;
      var x = currentObject.getLeft(), y = currentObject.getTop();
      var w = currentObject.getWidth(), h = currentObject.getHeight();
      var maxX = canvas.getWidth() - w;
      var maxY = canvas.getHeight() - h;

      if (x < 0)
        currentObject.set('left', 0);
      if (y < 0)
        currentObject.set('top', 0);
      if (x > maxX)
        currentObject.set('left', maxX);
      if (y > maxY)
        currentObject.set('top', maxY);

      this.darkroom.dispatchEvent('crop:update');
    },

    // Prevent crop zone from going beyond the canvas edges (like mouseMove)
    onObjectScaling: function(event) {
      if (!this.hasFocus()) {
        return;
      }

      var preventScaling = false;
      var currentObject = event.target;
      if (currentObject !== this.cropZone)
        return;

      var canvas = this.darkroom.canvas;
      var pointer = canvas.getPointer(event.e);
      var x = pointer.x;
      var y = pointer.y;

      var minX = currentObject.getLeft();
      var minY = currentObject.getTop();
      var maxX = currentObject.getLeft() + currentObject.getWidth();
      var maxY = currentObject.getTop() + currentObject.getHeight();

      if (null !== this.options.ratio) {
        if (minX < 0 || maxX > canvas.getWidth() || minY < 0 || maxY > canvas.getHeight()) {
          preventScaling = true;
        }
      }

      if (minX < 0 || maxX > canvas.getWidth() || preventScaling) {
        var lastScaleX = this.lastScaleX || 1;
        currentObject.setScaleX(lastScaleX);
      }
      if (minX < 0) {
        currentObject.setLeft(0);
      }

      if (minY < 0 || maxY > canvas.getHeight() || preventScaling) {
        var lastScaleY = this.lastScaleY || 1;
        currentObject.setScaleY(lastScaleY);
      }
      if (minY < 0) {
        currentObject.setTop(0);
      }

      if (currentObject.getWidth() < this.options.minWidth) {
        currentObject.scaleToWidth(this.options.minWidth);
      }
      if (currentObject.getHeight() < this.options.minHeight) {
        currentObject.scaleToHeight(this.options.minHeight);
      }

      this.lastScaleX = currentObject.getScaleX();
      this.lastScaleY = currentObject.getScaleY();

      this.darkroom.dispatchEvent('crop:update');
    },

    // Init crop zone
    onMouseDown: function(event) {
      if (!this.hasFocus()) {
        return;
      }

      var canvas = this.darkroom.canvas;

      // recalculate offset, in case canvas was manipulated since last `calcOffset`
      canvas.calcOffset();
      var pointer = canvas.getPointer(event.e);
      var x = pointer.x;
      var y = pointer.y;
      var point = new fabric.Point(x, y);

      // Check if user want to scale or drag the crop zone.
      var activeObject = canvas.getActiveObject();
      if (activeObject === this.cropZone || this.cropZone.containsPoint(point)) {
        return;
      }

      canvas.discardActiveObject();
      this.cropZone.setWidth(0);
      this.cropZone.setHeight(0);
      this.cropZone.setScaleX(1);
      this.cropZone.setScaleY(1);

      this.startX = x;
      this.startY = y;
    },

    // Extend crop zone
    onMouseMove: function(event) {
      // Quick crop feature
      if (this.isKeyCroping)
        return this.onMouseMoveKeyCrop(event);

      if (null === this.startX || null === this.startY) {
        return;
      }

      var canvas = this.darkroom.canvas;
      var pointer = canvas.getPointer(event.e);
      var x = pointer.x;
      var y = pointer.y;

      this._renderCropZone(this.startX, this.startY, x, y);
    },

    onMouseMoveKeyCrop: function(event) {
      var canvas = this.darkroom.canvas;
      var zone = this.cropZone;

      var pointer = canvas.getPointer(event.e);
      var x = pointer.x;
      var y = pointer.y;

      if (!zone.left || !zone.top) {
        zone.setTop(y);
        zone.setLeft(x);
      }

      this.isKeyLeft =  x < zone.left + zone.width / 2 ;
      this.isKeyUp = y < zone.top + zone.height / 2 ;

      this._renderCropZone(
        Math.min(zone.left, x),
        Math.min(zone.top, y),
        Math.max(zone.left+zone.width, x),
        Math.max(zone.top+zone.height, y)
      );
    },

    // Finish crop zone
    onMouseUp: function(event) {
      if (null === this.startX || null === this.startY) {
        return;
      }

      var canvas = this.darkroom.canvas;
      this.cropZone.setCoords();
      canvas.setActiveObject(this.cropZone);
      canvas.calcOffset();

      this.startX = null;
      this.startY = null;
    },

    onKeyDown: function(event) {
      if (false === this.options.quickCropKey || event.keyCode !== this.options.quickCropKey || this.isKeyCroping)
        return;

      // Active quick crop flow
      this.isKeyCroping = true ;
      this.darkroom.canvas.discardActiveObject();
      this.cropZone.setWidth(0);
      this.cropZone.setHeight(0);
      this.cropZone.setScaleX(1);
      this.cropZone.setScaleY(1);
      this.cropZone.setTop(0);
      this.cropZone.setLeft(0);
    },

    onKeyUp: function(event) {
      if (false === this.options.quickCropKey || event.keyCode !== this.options.quickCropKey || !this.isKeyCroping)
        return;

      // Unactive quick crop flow
      this.isKeyCroping = false;
      this.startX = 1;
      this.startY = 1;
      this.onMouseUp();
    },

    selectZone: function(x, y, width, height, forceDimension) {
      if (!this.hasFocus())
        this.requireFocus();

      if (!forceDimension) {
        this._renderCropZone(x, y, x+width, y+height);
      } else {
        this.cropZone.set({
          'left': x,
          'top': y,
          'width': width,
          'height': height
        });
      }

      var canvas = this.darkroom.canvas;
      canvas.bringToFront(this.cropZone);
      this.cropZone.setCoords();
      canvas.setActiveObject(this.cropZone);
      canvas.calcOffset();

      this.darkroom.dispatchEvent('crop:update');
    },

    toggleCrop: function() {
      if (!this.hasFocus())
        this.requireFocus();
      else
        this.releaseFocus();
    },

    cropCurrentZone: function() {
      if (!this.hasFocus()) {
        return;
      }

      // Avoid croping empty zone
      if (this.cropZone.width < 1 && this.cropZone.height < 1)
        return;

      var _this = this;
      var darkroom = this.darkroom;
      var canvas = darkroom.canvas;

      // Hide crop rectangle to avoid snapshot it with the image
      this.cropZone.visible = false;

      // Snapshot the image delimited by the crop zone
      var image = new Image();
      image.onload = function() {
        // Validate image
        if (this.height < 1 || this.width < 1) {
          return;
        }

        var imgInstance = new fabric.Image(this, {
          // options to make the image static
          selectable: false,
          evented: false,
          lockMovementX: true,
          lockMovementY: true,
          lockRotation: true,
          lockScalingX: true,
          lockScalingY: true,
          lockUniScaling: true,
          hasControls: false,
          hasBorders: false
        });

        var width = this.width;
        var height = this.height;

        // Update canvas size
        canvas.setWidth(width);
        canvas.setHeight(height);

        // Add image
        _this.darkroom.image.remove();
        _this.darkroom.image = imgInstance;
        canvas.add(imgInstance);

        darkroom.dispatchEvent('image:change');
      };

      image.src = canvas.toDataURL({
        left: this.cropZone.getLeft(),
        top: this.cropZone.getTop(),
        width: this.cropZone.getWidth(),
        height: this.cropZone.getHeight()
      });
    },

    // Test wether crop zone is set
    hasFocus: function() {
      return this.cropZone !== undefined;
    },

    // Create the crop zone
    requireFocus: function() {
      this.cropZone = new CropZone({
        fill: 'transparent',
        hasBorders: false,
        originX: 'left',
        originY: 'top',
        //stroke: '#444',
        //strokeDashArray: [5, 5],
        //borderColor: '#444',
        cornerColor: '#444',
        cornerSize: 8,
        transparentCorners: false,
        lockRotation: true,
        hasRotatingPoint: false,
      });

      if (null !== this.options.ratio) {
        this.cropZone.set('lockUniScaling', true);
      }

      this.darkroom.canvas.add(this.cropZone);
      this.darkroom.canvas.defaultCursor = 'crosshair';

      this.cropButton.active(true);
      this.okButton.hide(false);
      this.cancelButton.hide(false);
    },

    // Remove the crop zone
    releaseFocus: function() {
      if (undefined === this.cropZone)
        return;

      this.cropZone.remove();
      this.cropZone = undefined;

      this.cropButton.active(false);
      this.okButton.hide(true);
      this.cancelButton.hide(true);

      this.darkroom.canvas.defaultCursor = 'default';

      this.darkroom.dispatchEvent('crop:update');
    },

    _renderCropZone: function(fromX, fromY, toX, toY) {
      var canvas = this.darkroom.canvas;

      var isRight = (toX > fromX);
      var isLeft = !isRight;
      var isDown = (toY > fromY);
      var isUp = !isDown;

      var minWidth = Math.min(+this.options.minWidth, canvas.getWidth());
      var minHeight = Math.min(+this.options.minHeight, canvas.getHeight());

      // Define corner coordinates
      var leftX = Math.min(fromX, toX);
      var rightX = Math.max(fromX, toX);
      var topY = Math.min(fromY, toY);
      var bottomY = Math.max(fromY, toY);

      // Replace current point into the canvas
      leftX = Math.max(0, leftX);
      rightX = Math.min(canvas.getWidth(), rightX);
      topY = Math.max(0, topY)
      bottomY = Math.min(canvas.getHeight(), bottomY);

      // Recalibrate coordinates according to given options
      if (rightX - leftX < minWidth) {
        if (isRight)
          rightX = leftX + minWidth;
        else
          leftX = rightX - minWidth;
      }
      if (bottomY - topY < minHeight) {
        if (isDown)
          bottomY = topY + minHeight;
        else
          topY = bottomY - minHeight;
      }

      // Truncate truncate according to canvas dimensions
      if (leftX < 0) {
        // Translate to the left
        rightX += Math.abs(leftX);
        leftX = 0
      }
      if (rightX > canvas.getWidth()) {
        // Translate to the right
        leftX -= (rightX - canvas.getWidth());
        rightX = canvas.getWidth();
      }
      if (topY < 0) {
        // Translate to the bottom
        bottomY += Math.abs(topY);
        topY = 0
      }
      if (bottomY > canvas.getHeight()) {
        // Translate to the right
        topY -= (bottomY - canvas.getHeight());
        bottomY = canvas.getHeight();
      }

      var width = rightX - leftX;
      var height = bottomY - topY;
      var currentRatio = width / height;

      if (this.options.ratio && +this.options.ratio !== currentRatio) {
        var ratio = +this.options.ratio;

        if(this.isKeyCroping) {
          isLeft = this.isKeyLeft;
          isUp = this.isKeyUp;
        }

        if (currentRatio < ratio) {
          var newWidth = height * ratio;
          if (isLeft) {
            leftX -= (newWidth - width);
          }
          width = newWidth;
        } else if (currentRatio > ratio) {
          var newHeight = height / (ratio * height/width);
          if (isUp) {
            topY -= (newHeight - height);
          }
          height = newHeight;
        }

        if (leftX < 0) {
          leftX = 0;
          //TODO
        }
        if (topY < 0) {
          topY = 0;
          //TODO
        }
        if (leftX + width > canvas.getWidth()) {
          var newWidth = canvas.getWidth() - leftX;
          height = newWidth * height / width;
          width = newWidth;
          if (isUp) {
            topY = fromY - height;
          }
        }
        if (topY + height > canvas.getHeight()) {
          var newHeight = canvas.getHeight() - topY;
          width = width * newHeight / height;
          height = newHeight;
          if (isLeft) {
            leftX = fromX - width;
          }
        }
      }

      // Apply coordinates
      this.cropZone.left = leftX;
      this.cropZone.top = topY;
      this.cropZone.width = width;
      this.cropZone.height = height;

      this.darkroom.canvas.bringToFront(this.cropZone);

      this.darkroom.dispatchEvent('crop:update');
    }
  });
})(window, document, Darkroom, fabric);

;(function(window, document, Darkroom) {
  'use strict';

  Darkroom.plugins['save'] = Darkroom.Plugin.extend({
    defaults: {
      callback: function() {
        this.darkroom.selfDestroy();
      }
    },

    initialize: function InitDarkroomSavePlugin() {
      var buttonGroup = this.darkroom.toolbar.createButtonGroup();

      this.destroyButton = buttonGroup.createButton({
        image: 'save'
      });

      this.destroyButton.addEventListener('click', this.options.callback.bind(this));
    },
  });
})(window, document, Darkroom);
