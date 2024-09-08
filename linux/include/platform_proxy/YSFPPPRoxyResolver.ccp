#include "YSFPPProxy.h"
#include <sstream>

YSFPPProxy::YSFPPProxy(std::string host, std::string port, std::string user, std::string password, std::string type) {
    this->host = host;
    this->port = port;
    this->user = user;
    this->password = password;
    this->type = type;
}

std::string YSFPPProxy::json() {
    std::stringstream json;
    json << "{";
    json << "\"host\":\"" << host << "\",";
    json << "\"port\":\"" << port << "\",";
    json << "\"user\":\"" << user << "\",";
    json << "\"password\":\"" << password << "\",";
    json << "\"type\":\"" << type << "\"";
    json << "}";
    return json.str();
}
