package io.yamsergey.flutter.platform_proxy

import java.net.InetSocketAddress
import java.net.Proxy
import java.net.URI

private data class ProxyData(
    val host: String = "",
    val port: String = "",
    val type: String = "none",
    val user: String = "",
    val password: String = "",
) {
    override fun toString(): String {
        return "{\"host\":\"$host\",\"port\":\"$port\",\"type\":\"$type\",\"user\":\"$user\",\"password\":\"$password\"}"
    }

    companion object {

        fun from(schema: String, address: InetSocketAddress): ProxyData {
            return ProxyData(
                host = address.hostName,
                port = address.port.toString(),
                type = schema,
                user = "",
                password = ""
            )
        }
    }
}

internal class ProxyStringifier(private val proxies: List<Proxy>) {

    fun stringify(url: URI): String {
        return proxies.joinToString(prefix = "[", postfix = "]", separator = ",") { proxy ->
            val address = proxy.address()
            val type = proxy.type()

            when (type) {
                Proxy.Type.DIRECT -> ProxyData().toString()
                Proxy.Type.HTTP, Proxy.Type.SOCKS -> if (address is InetSocketAddress) {
                    ProxyData.from(url.scheme, address).toString()
                } else {
                    ""
                }
            }
        }
    }
}
