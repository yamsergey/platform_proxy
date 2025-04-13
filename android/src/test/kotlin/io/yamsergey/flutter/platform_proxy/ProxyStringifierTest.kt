package io.yamsergey.flutter.platform_proxy

import org.junit.jupiter.api.Assertions.assertEquals
import java.net.InetSocketAddress
import java.net.Proxy
import java.net.URI
import kotlin.test.Test

internal class ProxyStringifierTest {

    @Test
    fun `should stringify HTTP proxy`() {
        val proxy = ProxyStringifier(
            listOf(
                Proxy(Proxy.Type.HTTP, InetSocketAddress("localhost", 8080))
            )
        )
        val result = proxy.stringify(URI("http://example.com"))
        assertEquals(
            "[{\"host\":\"localhost\",\"port\":\"8080\",\"type\":\"http\",\"user\":\"\",\"password\":\"\"}]",
            result
        )
    }

    @Test
    fun `should stringify direct proxy`() {
        val proxy = ProxyStringifier(
            listOf(
                Proxy.NO_PROXY
            )
        )

        val result = proxy.stringify(URI("http://example.com"))
        assertEquals("[{\"host\":\"\",\"port\":\"\",\"type\":\"none\",\"user\":\"\",\"password\":\"\"}]", result)
    }

    @Test
    fun `should stringify multiple proxies`() {
        val proxy = ProxyStringifier(
            listOf(
                Proxy.NO_PROXY,
                Proxy(Proxy.Type.HTTP, InetSocketAddress("localhost", 1080)),
                Proxy(Proxy.Type.HTTP, InetSocketAddress("localhost", 8080)),
            )
        )

        val result = proxy.stringify(URI("http://example.com"))
        assertEquals("[{\"host\":\"\",\"port\":\"\",\"type\":\"none\",\"user\":\"\",\"password\":\"\"},{\"host\":\"localhost\",\"port\":\"1080\",\"type\":\"http\",\"user\":\"\",\"password\":\"\"},{\"host\":\"localhost\",\"port\":\"8080\",\"type\":\"http\",\"user\":\"\",\"password\":\"\"}]", result)
    }

    @Test
    fun `should stringify socks proxy`() {
        val proxy = ProxyStringifier(
            listOf(
                Proxy(Proxy.Type.SOCKS, InetSocketAddress("localhost", 1080))
            )
        )

        val result = proxy.stringify(URI("http://example.com"))
        assertEquals("[{\"host\":\"localhost\",\"port\":\"1080\",\"type\":\"http\",\"user\":\"\",\"password\":\"\"}]", result)
    }
}