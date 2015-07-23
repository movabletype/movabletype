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
        (this.options.postSelect || function() {})();
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
    var initialize = Darkroom.plugins.history.prototype.initialize;
    Darkroom.plugins.history.prototype.initialize = function() {
        (initialize.bind(this))();
        this.postUpdate = this.options.postUpdate || function() {};
    };

    var _onImageChange = Darkroom.plugins.history.prototype._onImageChange;
    Darkroom.plugins.history.prototype._onImageChange = function() {
        (_onImageChange.bind(this))();
        this.postUpdate();
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
                this.originalWidth = this.options.originalWidth;
                this.originalHeight = this.options.originalHeight;
                this.originalThumbnailWidth = this.options.originalThumbnailWidth;
                this.originalThumbnailHeight = this.options.originalThumbnailHeight;

                jQuery('div.darkroom-toolbar').remove();
            },
            plugins: {
                save: false
            },
        },

        // Parameters
        originalWidth: null,
        originalHeight: null,
        originalThumbnailWidth: null,
        originalThumbnailHeight: null,

        // Action stacks
        backActionStack: [],
        forwardActionStack: [],
        saveAction: function(action) {
            this.backActionStack.push(action);
            this.forwardActionStack = [];
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

            var cropLeft, cropTop, cropWidth, cropHeight;
            if (this.getAngle() % 180 === 0) {
                cropLeft   = Math.ceil(crop.cropZone.left * this.originalWidth / this.originalThumbnailWidth);
                cropTop    = Math.ceil(crop.cropZone.top * this.originalHeight / this.originalThumbnailHeight);
                cropWidth  = Math.ceil(crop.cropZone.width * this.originalWidth / this.originalThumbnailWidth);
                cropHeight = Math.ceil(crop.cropZone.height * this.originalHeight / this.originalThumbnailHeight);
            } else {
                cropLeft   = Math.ceil(crop.cropZone.left * this.originalHeight / this.originalThumbnailHeight);
                cropTop    = Math.ceil(crop.cropZone.top * this.originalWidth / this.originalThumbnailWidth);
                cropWidth  = Math.ceil(crop.cropZone.width * this.originalHeight / this.originalThumbnailHeight);
                cropHeight = Math.ceil(crop.cropZone.height * this.originalWidth / this.originalThumbnailWidth);
            }

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
        isFlippedX: function() {
            return this.image.flipX;
        },
        isFlippedY: function() {
            return this.image.flipY;
        },

        // History
        undo: function() {
            var history = this.getPlugin('history');
            history.goBack();

            this.undoAction();

            // Resize.
            if (this.backActionStack.length > 0) {
                var resize = this.backActionStack[0].resize;
                if (resize) {
                    this.resize(resize.width, resize.height, true);
                }
            }

            history.postUpdate();
        },
        redo: function() {
            var history = this.getPlugin('history');
            history.goForward();

            this.redoAction();

            // Resize.
            if (this.backActionStack.length > 0) {
                var resize = this.backActionStack[0].resize;
                if (resize) {
                    this.resize(resize.width, resize.height, true);
                }
            }

            history.postUpdate();
        },
        undoSize: function() {
            return this.getPlugin('history').backHistoryStack.length;
        },
        redoSize: function() {
            return this.getPlugin('history').forwardHistoryStack.length;
        },

        // Resize
        resize: function(width, height, noSaveAction) {
            var thumbnailWidth, thumbnailHeight;
            if (this.getAngle() % 180 === 0) {
                thumbnailWidth = Math.ceil(width * this.originalThumbnailWidth / this.originalWidth);
                thumbnailHeight = Math.ceil(height * this.originalThumbnailHeight / this.originalHeight);
            } else {
                thumbnailWidth = Math.ceil(width * this.originalThumbnailHeight / this.originalHeight);
                thumbnailHeight = Math.ceil(height * this.originalThumbnailWidth / this.originalWidth);
            }
            this.getPlugin('resize').resize(thumbnailWidth, thumbnailHeight);

            this.dispatchEvent('image:change');

            if (!noSaveAction) {
                this.saveAction({
                    resize: {
                        width: width,
                        height: height
                    }
                });
            }
        },
        getWidth: function() {
            if (this.getAngle() % 180 === 0) {
                return Math.ceil(this.getThumbnailWidth() * this.originalWidth / this.originalThumbnailWidth);
            } else {
                return Math.ceil(this.getThumbnailWidth() * this.originalHeight / this.originalThumbnailHeight);
            }
        },
        getHeight: function() {
            if (this.getAngle() % 180 === 0) {
                return Math.ceil(this.getThumbnailHeight() * this.originalHeight / this.originalThumbnailHeight);
            } else {
                return Math.ceil(this.getThumbnailHeight() * this.originalWidth / this.originalThumbnailWidth);
            }
        },
        getThumbnailWidth: function() {
            return jQuery(this.container).find('div.canvas-container').width();
        },
        getThumbnailHeight: function() {
            return jQuery(this.container).find('div.canvas-container').height();
        },

        // Rotate
        rotate: function(angle) {
            this.getPlugin('rotate').rotate(angle);
            this.saveAction({
                rotate: angle
            });
        },
        getAngle: function() {
            var angle = this.image.angle;
            if (angle < 0) angle += 360;  // Return positive value only.
            return angle;
        }
    });

    window.ImageEditor = ImageEditor;

})(window, document, Darkroom, jQuery);
