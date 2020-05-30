#
#                       mconnect solutions
#        (c) Copyright 2020 Abi Akindele (mconnect.biz)
#
#    See the file "LICENSE.md", included in this
#    distribution, for details about the copyright / license.
# 
#             Hash In-Memory Cache - Hash Table/Dictionary
#

import json, tables, times

## Type definition for the hash / cache values and response
type
    HashValue* = ref object
        value*: JsonNode
        expire*: Time
    HashCacheValue* = Table[string, HashValue]
    HashCacheResponse* = object
        ok*: bool
        message*: string
        value*: JsonNode

# Initialise hash-cache tables/objects
# var cacheRecord* = initTable[string, HashValue]()
var mcCache* = initTable[string, Table[string, HashValue]]()

# hash format
# const abc = {
#     key: {hashkey: {value: 1, expire: 2}}
# }

# secret keyCode for added security
const keyCode = "mcconnect_20200320_myjoy"

proc setHashCache*(key: string; hash: string, value: JsonNode; expire: Positive = 300): HashCacheResponse = 
    try:
        if key == "" or hash == "" or value == nil:
            return HashCacheResponse(ok: false, message: "key, hash and value are required")
        let cacheKey = key & keyCode
        let hashKey = hash & keyCode
        if not mcCache.hasKey(cacheKey):
            mcCache[cacheKey] = HashCacheValue()
        if not mcCache[cacheKey].hasKey(hashKey):
            mcCache[cacheKey][hashKey] = HashValue()
        let hashValue = HashValue(value: value, expire: getTime() + expire.seconds)
        mcCache[cacheKey][hashKey] = hashValue
        return HashCacheResponse(
                ok: true,
                message: "task completed successfully",
                value: value)
    except:
        return HashCacheResponse(ok: true, message: getCurrentExceptionMsg())

proc getHashCache*(key, hash: string;): HashCacheResponse = 
    try:
        let cacheKey = key & keyCode
        let hashKey = hash & keyCode

        # Ensure valide cache-key and hash-key
        if key == "" or hash == "":
            return HashCacheResponse(ok: false, message: "cache key and hash are required")
        
        # get active (non-expired) cache content
        if mcCache.hasKey(cacheKey) and (mcCache[cacheKey]).hasKey(hashKey) and mcCache[cacheKey][hashKey].expire > getTime():   
            return HashCacheResponse(
                ok: true,
                message: "task completed successfully",
                value: mcCache[cacheKey][hashKey].value )
        # Remove expired cache content by hash-key
        elif mcCache.hasKey(cacheKey) and (mcCache[cacheKey]).hasKey(hashKey):
            mcCache[cacheKey].del(hashKey)
            return HashCacheResponse(ok: false, message: "cache expired and deleted")
        else:
            return HashCacheResponse(ok: false, message: "cache info does not exist")
    except:
        return HashCacheResponse(ok: false, message: getCurrentExceptionMsg())

proc deleteHashCache*(key, hash: string; by: string = "hash"): HashCacheResponse = 
    try:
        let cacheKey = key & keyCode
        let hashKey = hash & keyCode

        if key == "" or (hash == "" and by == "hash"):
            return HashCacheResponse(ok: false, message: "key and hash-key are required")
        
        if key != "" and by == "key" and mcCache.hasKey(cacheKey):
            mcCache.del(cacheKey)
            return HashCacheResponse(
                ok: true,
                message: "task completed successfully")
        elif key != "" and hash != "" and by == "hash" and mcCache.hasKey(cacheKey) and mcCache[cacheKey].hasKey(hashKey):
            mcCache[cacheKey].del(hashKey)
            return HashCacheResponse(
                ok: true,
                message: "task completed successfully")
        else:
            return HashCacheResponse(ok: false, message: "cache key is required or cache-key not found")
    except:
        return HashCacheResponse(ok: false, message: getCurrentExceptionMsg())

proc clearHashCache*() : HashCacheResponse = 
    try:
        # re-initialise cache (hash-table)
        mcCache = initTable[string, Table[string, HashValue]]()
        return HashCacheResponse(ok: true, message: "task completed successfully")
    except:
        return HashCacheResponse(ok: false, message: getCurrentExceptionMsg())
