package meli.grails

import grails.converters.JSON
import groovy.json.JsonSlurper

class APIController {

    def index() {
//        def url = new URL("https://api.mercadolibre.com/sites")
        def url = new URL("http://localhost:8081/marcas")
        def connection = (HttpURLConnection) url.openConnection()
        connection.setRequestMethod("GET")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozilla/5.0")
        JsonSlurper json = new JsonSlurper()
        def sites = json.parse(connection.getInputStream())
        [sites:sites]
    }

    def categories(String selected) {
//        def url = new URL("https://api.mercadolibre.com/sites/" + selected + "/categories")
        def url = new URL("http://localhost:8081/marcas/" + selected + "/articulos")
//        def url = new URL("http://localhost:8081/articulos/" + selected )
        def connection = (HttpURLConnection) url.openConnection()
        connection.setRequestMethod("GET")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozilla/5.0")
        JsonSlurper json = new JsonSlurper()
        def categories = json.parse(connection.getInputStream())
        def resultado = [categories:categories]
        render resultado as JSON


    }

    def subCategories(String id) {
//        def url = new URL("https://api.mercadolibre.com/categories/" + id)
        def url = new URL("http://localhost:8081/articulos/" + id)
        def connection = (HttpURLConnection) url.openConnection()
        connection.setRequestMethod("GET")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozilla/5.0")
        JsonSlurper json = new JsonSlurper()
        def subCategories = json.parse(connection.getInputStream())
        def resultado = [subCategories:subCategories]
        render resultado as JSON


    }

    def deleteArticulo(String id) {
        def url = new URL("http://localhost:8081/articulos/" + id)
        def connection = (HttpURLConnection) url.openConnection()
        connection.setRequestMethod("DELETE")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozilla/5.0")
        JsonSlurper json = new JsonSlurper()
        connection.getInputStream()
        def resultado = connection.responseCode
        render resultado

    }

    def editArticulo(String id, String data) {
        def url = new URL("http://localhost:8081/articulos/" + id);
        def conn = (HttpURLConnection) url.openConnection()
        conn.setDoOutput(true);
        conn.setDoInput(true);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestMethod("PUT");
        OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
        wr.write(data);
        wr.flush();
        JsonSlurper json = new JsonSlurper()
        def response = json.parse(conn.getInputStream())
        return response
    }

    def addArticulo(String data) {
        def url = new URL("http://localhost:8081/articulos");
        def conn = (HttpURLConnection) url.openConnection()
        conn.setDoOutput(true);
        conn.setDoInput(true);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestMethod("POST");
        OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
        wr.write(data);
        wr.flush();
        JsonSlurper json = new JsonSlurper()
        def response = json.parse(conn.getInputStream())
        return response
    }
}
