#pragma once

#include <string>

class YSFPPProxy {
private:
    std::string host;
    std::string port;
    std::string user;
    std::string password;
    std::string type;
public:
    YSFPPProxy(std::string host, std::string port, std::string user, std::string password, std::string type);
    std::string json();
};
