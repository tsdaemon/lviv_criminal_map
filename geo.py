import numpy as np
import http.client as http
from urllib.parse import quote
import json
from time import sleep


api_key = "AIzaSyAWSGLYLbKRUBwxPd0HC5slbj4s_Zk-Lxc"
def request_gecoding_google(street, housenum=None):
    address = ""
    if(housenum != None and str(housenum) != "nan"):
        address += str(housenum) + " "
    address += street + ", Львів"
    query = "/maps/api/geocode/json?address=" + quote(address) + "&key=" + api_key
    
    conn = http.HTTPSConnection("maps.googleapis.com")
    conn.request("GET", query)
    res = conn.getresponse()
    js = json.loads(res.read().decode("utf-8"))
    if(js["status"] != "OK"): 
        if(js["status"] == "OVER_QUERY_LIMIT"):
            sleep(10)
            return request_gecoding(street, housenum)
        
        if(js["status"] == "ZERO_RESULTS"):
            return None
        
        message = "API error: " + js["status"]
        if("error_message" in js):
            message += ", message: " + js["error_message"]
        message += ", query: " + "https://maps.googleapis.com" + query
        message += ", address: " + address
        raise Exception(message)
        
    lat = float(js["results"][0]["geometry"]["location"]["lat"])
    lng = float(js["results"][0]["geometry"]["location"]["lng"])
    sleep(1)
    return (lat, lng)
	

def request_gecoding_osm(street, housenum=None):
    address = ""
    if(housenum != None and str(housenum) != "nan"):
        address += str(housenum) + " "
    address += street + ", Львів"
    query = "/search/" + quote(address) + "?format=json"
    #return "nominatim.openstreetmap.org"+query
    
    conn = http.HTTPConnection("nominatim.openstreetmap.org")
    conn.request("GET", query)
    res = conn.getresponse()
    js_str = res.read().decode("utf-8")
    
    try:
        js = json.loads(js_str)
    except json.JSONDecodeError:
        # limit reached
        sleep(60)
        return(street, housenum)
        
    if(len(js) == 0):
        return None
    
    item = js[0]
    
    lat = float(item["lat"])
    lon = float(item["lon"])
    sleep(1)
    return (lat, lon)