(function(window, document, Darkroom, jQuery) {
    'use strict';

    // Crop plugin
    var onMouseDown = Darkroom.plugins.crop.prototype.onMouseDown;
    Darkroom.plugins.crop.prototype.onMouseDown = function(event) {
        var _this = this.darkroom.plugins.crop;
        // Start cropping automatically when clicking the image.
        if (!_this.hasFocus()) {
            _this.requireFocus();
        }
        (onMouseDown.bind(_this))(event);
    };

    var onMouseUp = Darkroom.plugins.crop.prototype.onMouseUp;
    Darkroom.plugins.crop.prototype.onMouseUp = function(event) {
        var _this = this.darkroom.plugins.crop;
        (onMouseUp.bind(_this))(event);
        // Start event after cropping.
        (_this.options.postSelect || function() {})();
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
    Darkroom.plugins.history = Darkroom.Plugin.extend({
        initialize: function InitDarkroomHistoryPlugin() {
            this.backHistoryStack = [];
            this.forwardHistoryStack = [];

            this.postUpdate = this.options.postUpdate || function() {};

            this._snapshotImage();

            this.darkroom.addEventListener('image:change', this._onImageChange.bind(this));
        },

        goBack: function() {
            if (this.backHistoryStack.length === 0) {
                return;
            }

            this.forwardHistoryStack.push({
                image: this.currentImage,
                width: this.currentWidth,
                height: this.currentHeight,
                angle: this.currentAngle,
                flipX: this.currentFlipX,
                flipY: this.currentFlipY
            });

            var history = this.backHistoryStack.pop();

            this.currentImage = history.image;
            this._applyImage(this.currentImage);

            this.currentWidth = history.width;
            this.currentHeight = history.height;
            this.darkroom.getPlugin('resize').resize(this.currentWidth, this.currentHeight);

            this.currentAngle = history.angle;
            this.darkroom.image.setAngle(this.currentAngle);

            this.currentFlipX = history.flipX;
            this.darkroom.image.setFlipX(this.currentFlipX);

            this.currentFlipY = history.flipY;
            this.darkroom.image.setFlipY(this.currentFlipY);

            // Dispatch an event, so listeners will know the
            // currently viewed image has been changed.
            this.darkroom.dispatchEvent('history:navigate');
        },

        goForward: function() {
            if (this.forwardHistoryStack.length === 0) {
                return;
            }

            this.backHistoryStack.push({
                image: this.currentImage,
                width: this.currentWidth,
                height: this.currentHeight,
                angle: this.currentAngle,
                flipX: this.currentFlipX,
                flipY: this.currentFlipY
            });

            var history = this.forwardHistoryStack.pop();

            this.currentImage = history.image;
            this._applyImage(this.currentImage);

            this.currentWidth = history.width;
            this.currentHeight = history.height;
            this.darkroom.getPlugin('resize').resize(this.currentWidth, this.currentHeight);

            this.currentAngle = history.angle;
            this.darkroom.image.setAngle(this.currentAngle);

            this.currentFlixX = history.flipX;
            this.darkroom.image.setFlipX(this.currentFlipX);

            this.currentFlipY = history.flipY;
            this.darkroom.image.setFlipY(this.currentFlipY);

            // Dispatch an event, so listeners will know the
            // currently viewed image has been changed.
            this.darkroom.dispatchEvent('history:navigate');
        },

        _snapshotImage: function() {
            var _this = this;
            var image = new Image();
            image.src = this.darkroom.snapshotImage();

            var $resizable = jQuery(this.darkroom.container).find('div.canvas-container');

            this.currentImage = image;
            this.currentWidth = $resizable.width();
            this.currentHeight = $resizable.height();
            this.currentAngle = this.darkroom.image.getAngle();
            this.currentFlipX = this.darkroom.image.getFlipX();
            this.currentFlipY = this.darkroom.image.getFlipY();
        },

        _onImageChange: function() {
            this.backHistoryStack.push({
                image: this.currentImage,
                width: this.currentWidth,
                height: this.currentHeight,
                angle: this.currentAngle,
                flipX: this.currentFlipX,
                flipY: this.currentFlipY
            });
            this._snapshotImage();
            this.forwardHistoryStack.length = 0;

            this.postUpdate();
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
        options = jQuery.extend(true, options, this.defaults);
        var _this = new Darkroom(element, options);

        _this.originalWidth = options.originalWidth;
        _this.originalHeight = options.originalHeight;
        _this.originalThumbnailWidth = options.originalThumbnailWidth;
        _this.originalThumbnailHeight = options.originalThumbnailHeight;

        return _this;
    }

    ImageEditor.prototype = jQuery.extend(Darkroom.prototype, {
        defaults: {
            init: function() {
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

        // Crop
        crop: function() {
            this.getPlugin('crop').cropCurrentZone();
        },
        cropCancel: function() {
            this.getPlugin('crop').releaseFocus();
        },

        // Flip
        flipHorizontal: function() {
            this.getPlugin('flip').flip('horizontal');
        },
        flipVertical: function() {
            this.getPlugin('flip').flip('vertical');
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
            history.postUpdate();
        },
        redo: function() {
            var history = this.getPlugin('history');
            history.goForward();
            history.postUpdate();
        },
        undoSize: function() {
            return this.getPlugin('history').backHistoryStack.length;
        },
        redoSize: function() {
            return this.getPlugin('history').forwardHistoryStack.length;
        },

        // Resize
        resize: function(width, height) {
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
        },
        getAngle: function() {
            var angle = this.image.angle;
            if (angle < 0) angle += 360;  // Return positive value only.
            return angle;
        }
    });

    window.ImageEditor = ImageEditor;

})(window, document, Darkroom, jQuery);
