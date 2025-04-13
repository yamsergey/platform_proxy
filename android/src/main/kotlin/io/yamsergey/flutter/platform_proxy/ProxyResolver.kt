package io.yamsergey.flutter.platform_proxy

import java.net.Proxy
import java.net.ProxySelector
import java.net.URI

/**
 * ProxyResolver is a class that resolves the proxy settings for a given URL.
 * It uses the system's default [ProxySelector] to get the list of proxies.
 *
 * Different request URL might be handled by different proxy settings that's why each one of them has to be resolved
 * separately.
 */
internal class ProxyResolver {
    fun resolve(url: String): List<Proxy> {
        val proxies = ProxySelector.getDefault().select(URI.create(url))
        return proxies
    }
}