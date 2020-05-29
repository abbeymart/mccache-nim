#
#              mconnect solutions
#        (c) Copyright 2020 Abi Akindele (mconnect.biz)
#
#    See the file "LICENSE.md", included in this
#    distribution, for details about the copyright / license.
# 
#            Simple In-Memory Cache - Table/Dictionary
#

import json, tables, times

## Type definition for the cache response
type
    CacheValue* = ref object
        value*: JsonNode
        expire*: Time
    CacheResponse* = object
        ok*: bool
        message*: string
        value*: JsonNode

# Initialise cache table/object
var mcCache* = initTable[string, CacheValue]()

# secret keyCode for added security
const keyCode = "mcconnect_20200320_myjoy"

proc setCache*(key: string; value: JsonNode; expire: Positive = 300): CacheResponse = 
    try:
        if key == "" or value == nil:
            return CacheResponse(ok: false, message: "key and value are required")
        let cacheKey = key & keyCode
        mcCache[cacheKey] = CacheValue(value: value, expire: getTime() + expire.seconds)
        return CacheResponse(
                ok: true,
                message: "cache task completed successfully",
                value: value)
    except:
            return CacheResponse(ok: false, message: getCurrentExceptionMsg())

proc getCache*(key: string;): CacheResponse = 
    try:
        let cacheKey = key & keyCode
        if key == "":
            return CacheResponse(ok: false, message: "cache key is required")
        elif mcCache.hasKey(cacheKey) and mcCache[cacheKey].expire > getTime():
            return CacheResponse(
                ok: true,
                message: "cache task completed successfully",
                value: mcCache[cacheKey].value)
        elif mcCache.hasKey(cacheKey):
            mcCache.del(cacheKey)
            return CacheResponse(ok: false, message: "cache expired and deleted")
        else:
            return CacheResponse(ok: false, message: "cache info does not exist")
    except:
        return CacheResponse(ok: false, message: getCurrentExceptionMsg())

proc deleteCache*(key: string;): CacheResponse = 
    try:
        let cacheKey = key & keyCode
        if key == "":
            return CacheResponse(ok: false, message: "key is required")

        if mcCache.hasKey(cacheKey):
            mcCache.del(cacheKey)
            return CacheResponse(
                ok: true,
                message: "cache task (delete) completed successfully")
        else:
            return CacheResponse(ok: false, message: "task not completed, cache-key not found")
    except:
        return CacheResponse(ok: false, message: getCurrentExceptionMsg())

proc clearCache*() : CacheResponse = 
    try:
        # re-initialise cache (table)
        mcCache = initTable[string, CacheValue]()
        return CacheResponse(ok: true, message: "cache cleared successfully")
    except:
        return CacheResponse(ok: false, message: getCurrentExceptionMsg())
