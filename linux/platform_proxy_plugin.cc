#include "include/platform_proxy/platform_proxy_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>
#include <json-glib/json-glib.h>

#include <cstring>

#include "platform_proxy_plugin_private.h"

#define PLATFORM_PROXY_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), platform_proxy_plugin_get_type(), \
                              PlatformProxyPlugin))

struct _PlatformProxyPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(PlatformProxyPlugin, platform_proxy_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void platform_proxy_plugin_handle_method_call(
    PlatformProxyPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformProxy") == 0) {
    FlValue* args = fl_method_call_get_args(method_call);
    const gchar* url = nullptr;
    if (fl_value_get_type(args) == FL_VALUE_TYPE_MAP) {
      FlValue* url_value = fl_value_lookup_string(args, "url");
      if (url_value && fl_value_get_type(url_value) == FL_VALUE_TYPE_STRING) {
        url = fl_value_get_string(url_value);
      }
    }
    response = get_platform_proxy(url);
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

FlMethodResponse* get_platform_proxy(const gchar* url) {
  // Read proxy environment variables
  const char* http_proxy = getenv("http_proxy");
  const char* https_proxy = getenv("https_proxy");
  const char* no_proxy = getenv("no_proxy");

  // Build a JSON array of proxies (mimicking your macOS/iOS output)
  JsonBuilder* builder = json_builder_new();
  json_builder_begin_array(builder);

  if (http_proxy) {
    json_builder_begin_object(builder);
    json_builder_set_member_name(builder, "host");
    json_builder_add_string_value(builder, http_proxy);
    json_builder_set_member_name(builder, "port");
    json_builder_add_string_value(builder, "");
    json_builder_set_member_name(builder, "user");
    json_builder_add_string_value(builder, "");
    json_builder_set_member_name(builder, "password");
    json_builder_add_string_value(builder, "");
    json_builder_set_member_name(builder, "type");
    json_builder_add_string_value(builder, "http");
    json_builder_end_object(builder);
  }
  if (https_proxy) {
    json_builder_begin_object(builder);
    json_builder_set_member_name(builder, "host");
    json_builder_add_string_value(builder, https_proxy);
    json_builder_set_member_name(builder, "port");
    json_builder_add_string_value(builder, "");
    json_builder_set_member_name(builder, "user");
    json_builder_add_string_value(builder, "");
    json_builder_set_member_name(builder, "password");
    json_builder_add_string_value(builder, "");
    json_builder_set_member_name(builder, "type");
    json_builder_add_string_value(builder, "https");
    json_builder_end_object(builder);
  }
  // You can add more logic for parsing host/port/user/password if needed

  json_builder_end_array(builder);

  JsonGenerator* gen = json_generator_new();
  JsonNode* root = json_builder_get_root(builder);
  json_generator_set_root(gen, root);
  gchar* json_str = json_generator_to_data(gen, nullptr);

  g_autoptr(FlValue) result = fl_value_new_string(json_str);

  g_free(json_str);
  g_object_unref(gen);
  json_node_free(root);
  g_object_unref(builder);

  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static void platform_proxy_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(platform_proxy_plugin_parent_class)->dispose(object);
}

static void platform_proxy_plugin_class_init(PlatformProxyPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = platform_proxy_plugin_dispose;
}

static void platform_proxy_plugin_init(PlatformProxyPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  PlatformProxyPlugin* plugin = PLATFORM_PROXY_PLUGIN(user_data);
  platform_proxy_plugin_handle_method_call(plugin, method_call);
}

void platform_proxy_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  PlatformProxyPlugin* plugin = PLATFORM_PROXY_PLUGIN(
      g_object_new(platform_proxy_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "platform_proxy",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
