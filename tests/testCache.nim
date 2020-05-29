#
#              mconnect solutions
#        (c) Copyright 2020 Abi Akindele (mconnect.biz)
#
#    See the file "LICENSE.md", included in this
#    distribution, for details about the copyright / license.
# 
#          Testing for Simple In-Memory Cache - Table/Dictionary
#

import mccache, json, times, unittest

## Type definition for the cache response
type
    CacheValue* = ref object
        value*: JsonNode
        expire*: Time
    CacheResponse* = object
        ok*: bool
        message*: string
        value*: JsonNode

# types and test-values
var
    cacheValue: JsonNode = parseJson("""{"firstName": "Abi", "lastName": "Akindele", "location": "Toronto-Canada"}""")
    cacheKey: string = """{"name": "Tab1", "location": "Toronto"}"""
    expiryTime: Positive = 5 # in seconds
    # hashKey: string = """{"hash1": "Hash1", "hash2": "Hash2"}"""
    # res: CacheResponse = CacheResponse()

test "should set and return valid cacheValue":
    let setCache = setCache(cacheKey, cacheValue, expiryTime )
    if setCache.ok:
        # get cache content
        let res = getCache(cacheKey)
        echo "get-cache-response: ", res
        check res.ok == true
        check res.value == cacheValue
        check res.message == "cache task completed successfully"

test "should clear cache and return null/empty value":
    let setCache = setCache(cacheKey, cacheValue, expiryTime )
    if setCache.ok:
        # get cache content
        let res = getCache(cacheKey)
        echo "get-cache-response: ", res
        check res.ok == true
        check res.value == cacheValue
        check res.message == "cache task completed successfully"

test "should set and return valid cacheValue -> before timeout/expiration)":
    let setCache = setCache(cacheKey, cacheValue, expiryTime )
    if setCache.ok:
        # get cache content
        let res = getCache(cacheKey)
        echo "get-cache-response: ", res
        check res.ok == true
        check res.value == cacheValue
        check res.message == "cache task completed successfully"

test "should return null value after timeout/expiration":
    let setCache = setCache(cacheKey, cacheValue, expiryTime )
    if setCache.ok:
        # get cache content
        let res = getCache(cacheKey)
        echo "get-cache-response: ", res
        check res.ok == true
        check res.value == cacheValue
        check res.message == "cache task completed successfully"
