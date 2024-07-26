import { TinyMCE } from "tinymce6";
import tinymce from "tinymce5";

import "tinymce5/themes/silver/theme";
import "tinymce5/icons/default/icons";
import "tinymce5/plugins/media/plugin";

window.tinymce = tinymce as unknown as TinyMCE;
