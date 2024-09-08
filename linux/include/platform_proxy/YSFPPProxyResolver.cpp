#include "YSFPPProxyResolver.h"

// Helper method to get environment proxy variables
std::string YSFPPProxyResolver::getEnvProxy(const std::string& proxy_var) {
    const char* proxy = std::getenv(proxy_var.c_str());
    return proxy ? std::string(proxy) : "";
}

// GSettings method to get GNOME proxy configuration
std::string YSFPPProxyResolver::getGnomeProxyConfig() {
    GSettings *settings = g_settings_new("org.gnome.system.proxy");
    gchar *mode = g_settings_get_string(settings, "mode");

    std::string proxy_json = "{";

    if (g_strcmp0(mode, "manual") == 0) {
        gchar *http_host = g_settings_get_string(settings, "http-host");
        gint http_port = g_settings_get_int(settings, "http-port");

        proxy_json += "\"http_proxy\":\"" + std::string(http_host) + ":" + std::to_string(http_port) + "\"";

        g_free(http_host);
    }

    proxy_json += "}";

    g_free(mode);
    g_object_unref(settings);
    return proxy_json;
}

// Main method to resolve proxies on Linux
std::vector<YSFPPProxy> YSFPPProxyResolver::resolveProxies(std::string url) {
    std::vector<YSFPPProxy> proxies;

    // Check environment variables
    std::string http_proxy = getEnvProxy("http_proxy");
    std::string https_proxy = getEnvProxy("https_proxy");

    if (!http_proxy.empty()) {
        proxies.push_back(YSFPPProxy(http_proxy, "80", "", "", "http"));
    }

    if (!https_proxy.empty()) {
        proxies.push_back(YSFPPProxy(https_proxy, "443", "", "", "https"));
    }

    // Check GNOME proxy settings if environment variables are not found
    if (proxies.empty()) {
        std::string gnomeProxyConfig = getGnomeProxyConfig();
        // Parse GNOME proxy JSON string (if any) and add to proxies
        // Example here: parse the json to extract host and port (code omitted)
    }

    return proxies;
}

std::string YSFPPProxyResolver::resolveProxiesAsJson(std::string url) {
    std::vector<YSFPPProxy> proxies = this->resolveProxies(url);
    std::string result = "[";

    for (auto it = proxies.begin(); it != proxies.end(); ++it) {
        result += (*it).json();
        if (it != proxies.end() - 1) {
            result += ",";
        }
    }

    result += "]";
    return result;
}
