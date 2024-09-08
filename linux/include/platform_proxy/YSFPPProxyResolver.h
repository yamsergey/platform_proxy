#pragma once

#include <iostream>
#include <vector>
#include <cstdlib> // For getenv
#include "YSFPPProxy.h"
#include <gio/gio.h> // For GSettings (GNOME)

// The resolver class definition
class YSFPPProxyResolver {
public:
    std::vector<YSFPPProxy> resolveProxies(std::string url);
    std::string resolveProxiesAsJson(std::string url);

private:
    std::string getEnvProxy(const std::string& proxy_var);
    std::string getGnomeProxyConfig();
};
