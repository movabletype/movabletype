(function(window, document, Darkroom, jQuery) {
    'use strict';

    // Crop plugin
    var onMouseDown = Darkroom.plugins.crop.prototype.onMouseDown;
    Darkroom.plugins.crop.prototype.onMouseDown = function(event) {
        // Start cropping automatically when clicking the image.
        if (!this.hasFocus()) {
            this.requireFocus();
        }
        (onMouseDown.bind(this))(event);
    };

    var onMouseUp = Darkroom.plugins.crop.prototype.onMouseUp;
    Darkroom.plugins.crop.prototype.onMouseUp = function(event) {
        (onMouseUp.bind(this))(event);
        // Start event after cropping.
        (this.options.postSelectTrigger || function() {})();
    };

    // Flip plugin
    Darkroom.plugins.flip = Darkroom.Plugin.extend({
        flip: function(direction) {
            var darkroom = this.darkroom;
            var canvas = darkroom.canvas;
            var image = darkroom.image;

            /**
             * (direction === 'horizontal' && angle % 180 === 0) => flipX
             * (direction === 'horizontal' && angle % 180 !== 0) => flipY
             * (direction === 'vertical'   && angle % 180 === 0) => flipY
             * (direction === 'vertical'   && angle % 180 !== 0) => flipX

             "image.angle" is always zero after undoing/redoing image, but it is OK.
             */
            if (direction === 'horizontal' ^ image.angle % 180 === 0) {
                image.flipY ^= true;
            } else {
                image.flipX ^= true;
            }

            canvas.centerObject(image);
            image.setCoords();

            canvas.renderAll();

            // Create undo data.
            darkroom.dispatchEvent('image:change');
        }
    });

    // History plugin
    Darkroom.plugins.history.prototype.goBack = function() {
      if (this.backHistoryStack.length === 0) {
        return;
      }

      var darkroom = this.darkroom;

      this.forwardHistoryStack.push({
        image: this.currentImage,
        width: darkroom.width,
        height: darkroom.height,
        thumbnailWidth: darkroom.thumbnailWidth,
        thumbnailHeight: darkroom.thumbnailHeight,
      });

      var history = this.backHistoryStack.pop();

      this.currentImage = history.image;
      this._applyImage(this.currentImage);

      darkroom.width = history.width;
      darkroom.height = history.height;
      darkroom.thumbnailWidth = history.thumbnailWidth;
      darkroom.thumbnailHeight = history.thumbnailHeight;

      // Dispatch an event, so listeners will know the
      // currently viewed image has been changed.
      this.darkroom.dispatchEvent('history:navigate');
    };

    Darkroom.plugins.history.prototype.goForward = function() {
      if (this.forwardHistoryStack.length === 0) {
        return;
      }

      var darkroom = this.darkroom;

      this.backHistoryStack.push({
        image: this.currentImage,
        width: darkroom.width,
        height: darkroom.height,
        thumbnailWidth: darkroom.thumbnailWidth,
        thumbnailHeight: darkroom.thumbnailHeight
      });

      var history = this.forwardHistoryStack.pop();

      this.currentImage = history.image;
      this._applyImage(this.currentImage);

      darkroom.width = history.width;
      darkroom.height = history.height;
      darkroom.thumbnailWidth = history.thumbnailWidth;
      darkroom.thumbnailHeight = history.thumbnailHeight;

      // Dispatch an event, so listeners will know the
      // currently viewed image has been changed.
      this.darkroom.dispatchEvent('history:navigate');
    };

    Darkroom.plugins.history.prototype._onImageChange = function() {
        var darkroom = this.darkroom;

        this.backHistoryStack.push({
          image: this.currentImage,
          width: darkroom.width,
          height: darkroom.height,
          thumbnailWidth: darkroom.thumbnailWidth,
          thumbnailHeight: darkroom.thumbnailHeight,
        });

        // Parameters are updated here after cropping.
        if (darkroom.temporaryParameters) {
          var t = darkroom.temporaryParameters;
          darkroom.width = t.width;
          darkroom.height = t.height;
          darkroom.thumbnailWidth = t.thumbnailWidth;
          darkroom.thumbnailHeight = t.thumbnailHeight;
          delete darkroom.temporaryParameters;
        }

        this._snapshotImage();
        this.forwardHistoryStack.length = 0;

        this.darkroom.postActionTrigger();
    };

    // Resize plugin
    Darkroom.plugins.resize = Darkroom.Plugin.extend({
        resize: function(width, height) {
            var $div = jQuery(this.darkroom.container).find('div.canvas-container');

            $div.width(width)
                .height(height);

            $div.children('canvas').each(function() {
                jQuery(this)
                    .width(width)
                    .height(height);
            });
        }
    });

    // ImageEditor
    function ImageEditor(element, options) {
        this.init(element, options);
    }

    ImageEditor.prototype = jQuery.extend(true, Darkroom.prototype, {
        defaults: {
            init: function() {
                this.width = this.options.width;
                this.height = this.options.height;
                this.thumbnailWidth = this.options.thumbnailWidth;
                this.thumbnailHeight = this.options.thumbnailHeight;

                this.postActionTrigger = this.options.postActionTrigger || function() {};

                // Remove toolbar.
                jQuery('div.darkroom-toolbar').remove();
            },
            plugins: {
                save: false  // Disable save plugin.
            }
        },

        postActionTrigger: null,

        // Parameters
        width: null,
        height: null,
        thumbnailWidth: null,
        thumbnailHeight: null,

        // Action stacks
        backActionStack: [],
        forwardActionStack: [],
        saveAction: function(action) {
            this.backActionStack.push(action);
            this.forwardActionStack.length = 0;
        },
        undoAction: function() {
            this.forwardActionStack.push(this.backActionStack.pop());
        },
        redoAction: function() {
            this.backActionStack.push(this.forwardActionStack.pop());
        },

        // Crop
        crop: function() {
            var crop = this.getPlugin('crop');
            var canvas = this.canvas;

            var cropLeft = Math.ceil(crop.cropZone.left * this.width / canvas.width);
            var cropTop = Math.ceil(crop.cropZone.top * this.height / canvas.height);
            var cropWidth = Math.ceil(crop.cropZone.currentWidth * this.width / canvas.width);
            var cropHeight = Math.ceil(crop.cropZone.currentHeight * this.height / canvas.height);

            // Adjust width and height.
            if (cropLeft + cropWidth > this.width) {
                cropWidth = this.width - cropLeft;
            }
            if (cropTop + cropHeight > this.height) {
                cropHeight = this.height - cropTop;
            }

            var cropThumbnailWidth = Math.ceil(crop.cropZone.currentWidth * this.thumbnailWidth / canvas.width);
            var cropThumbnailHeight = Math.ceil(crop.cropZone.currentHeight * this.thumbnailHeight / canvas.height);

            // These parameters will be updated in 'image:change' trigger.
            this.temporaryParameters = {
              width: cropWidth,
              height: cropHeight,
              thumbnailWidth: cropThumbnailWidth,
              thumbnailHeight: cropThumbnailHeight
            };

            // Crop.
            crop.cropCurrentZone();

            this.saveAction({
                crop: {
                    left: cropLeft,
                    top: cropTop,
                    width: cropWidth,
                    height: cropHeight
                }
            });
        },
        cropCancel: function() {
            this.getPlugin('crop').releaseFocus();
        },

        // Flip
        flipHorizontal: function() {
            this.getPlugin('flip').flip('horizontal');
            this.saveAction({
                flip: 'horizontal'
            });
        },
        flipVertical: function() {
            this.getPlugin('flip').flip('vertical');
            this.saveAction({
                flip: 'vertical'
            });
        },

        // History
        undo: function() {
            this.getPlugin('history').goBack();
            this.undoAction();
            this.postActionTrigger();
        },
        redo: function() {
            this.getPlugin('history').goForward();
            this.redoAction();
            this.postActionTrigger();
        },
        undoSize: function() {
            return this.getPlugin('history').backHistoryStack.length;
        },
        redoSize: function() {
            return this.getPlugin('history').forwardHistoryStack.length;
        },

        // Resize
        resize: function(width, height, noSaveAction) {
            var thumbnailWidth = Math.ceil(width * this.thumbnailWidth / this.width);
            var thumbnailHeight = Math.ceil(height * this.thumbnailHeight / this.height);

            // Resize.
            this.getPlugin('resize').resize(thumbnailWidth, thumbnailHeight);

            // Save history.
            if (!noSaveAction) {
                this.dispatchEvent('image:change');

                this.saveAction({
                    resize: {
                        width: width,
                        height: height
                    }
                });
            }

            // Update current parameters.
            this.width = width;
            this.height = height;
            this.thumbnailWidth = thumbnailWidth;
            this.thumbnailHeight = thumbnailHeight;

            // Update dialog.
            this.postActionTrigger();
        },

        // Rotate
        rotate: function(angle) {
            // Rotate.
            this.getPlugin('rotate').rotate(angle);

            // Save action.
            this.saveAction({
                rotate: angle
            });

            // Update current parameters.
            var newHeight = this.width;
            this.width = this.height;
            this.height = newHeight;

            var newThumbnailHeight = this.thumbnailWidth;
            this.thumbnailWidth = this.thumbnailHeight;
            this.thumbnailHeight = newThumbnailHeight;

            // Update dialog.
            this.postActionTrigger();
        },
    });

    // Globalize.
    window.ImageEditor = ImageEditor;

})(window, document, Darkroom, jQuery);
