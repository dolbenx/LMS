/**
 * Copyright (c) Tiny Technologies, Inc. All rights reserved.
 * Licensed under the LGPL or a commercial license.
 * For LGPL see License.txt in the project root for license information.
 * For commercial licenses see https://www.tiny.cloud/
 *
 * Version: 5.4.2 (2020-08-17)
 */
!function(a){"use strict";var e,t=tinymce.util.Tools.resolve("tinymce.PluginManager"),r=tinymce.util.Tools.resolve("tinymce.util.Delay"),n=tinymce.util.Tools.resolve("tinymce.util.LocalStorage"),o=tinymce.util.Tools.resolve("tinymce.util.Tools"),i=function(t,e){var r=t||e,n=/^(\d+)([ms]?)$/.exec(""+r);return(n[2]?{s:1e3,m:6e4}[n[2]]:1)*parseInt(r,10)},u=function(t){var e=a.document.location;return t.getParam("autosave_prefix","tinymce-autosave-{path}{query}{hash}-{id}-").replace(/{path}/g,e.pathname).replace(/{query}/g,e.search).replace(/{hash}/g,e.hash).replace(/{id}/g,t.id)},s=(e=undefined,function(t){return e===t}),f=function(t,e){if(s(e))return t.dom.isEmpty(t.getBody());var r=o.trim(e);if(""===r)return!0;var n=(new a.DOMParser).parseFromString(r,"text/html");return t.dom.isEmpty(n)},c=function(t){var e=parseInt(n.getItem(u(t)+"time"),10)||0;return!((new Date).getTime()-e>i(t.getParam("autosave_retention"),"20m"))||(m(t,!1),!1)},m=function(t,e){var r=u(t);n.removeItem(r+"draft"),n.removeItem(r+"time"),!1!==e&&t.fire("RemoveDraft")},l=function(t){var e=u(t);!f(t)&&t.isDirty()&&(n.setItem(e+"draft",t.getContent({format:"raw",no_events:!0})),n.setItem(e+"time",(new Date).getTime().toString()),t.fire("StoreDraft"))},v=function(t){var e=u(t);c(t)&&(t.setContent(n.getItem(e+"draft"),{format:"raw"}),t.fire("RestoreDraft"))},d=function(t){var e=i(t.getParam("autosave_interval"),"30s");r.setInterval(function(){t.removed||l(t)},e)},g=function(t){t.undoManager.transact(function(){v(t),m(t)}),t.focus()},y=tinymce.util.Tools.resolve("tinymce.EditorManager"),D=function(r){return function(t){t.setDisabled(!c(r));var e=function(){return t.setDisabled(!c(r))};return r.on("StoreDraft RestoreDraft RemoveDraft",e),function(){return r.off("StoreDraft RestoreDraft RemoveDraft",e)}}};!function p(){t.add("autosave",function(t){var e,r;return t.editorManager.on("BeforeUnload",function(t){var e;o.each(y.get(),function(t){t.plugins.autosave&&t.plugins.autosave.storeDraft(),!e&&t.isDirty()&&t.getParam("autosave_ask_before_unload",!0)&&(e=t.translate("You have unsaved changes are you sure you want to navigate away?"))}),e&&(t.preventDefault(),t.returnValue=e)}),d(e=t),e.ui.registry.addButton("restoredraft",{tooltip:"Restore last draft",icon:"restore-draft",onAction:function(){g(e)},onSetup:D(e)}),e.ui.registry.addMenuItem("restoredraft",{text:"Restore last draft",icon:"restore-draft",onAction:function(){g(e)},onSetup:D(e)}),t.on("init",function(){t.getParam("autosave_restore_when_empty",!1)&&t.dom.isEmpty(t.getBody())&&v(t)}),r=t,{hasDraft:function(){return c(r)},storeDraft:function(){return l(r)},restoreDraft:function(){return v(r)},removeDraft:function(t){return m(r,t)},isEmpty:function(t){return f(r,t)}}})}()}(window);