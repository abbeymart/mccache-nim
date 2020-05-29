#
#              mconnect solutions
#        (c) Copyright 2020 Abi Akindele (mconnect.biz)
#
#    See the file "LICENSE.md", included in this
#    distribution, for details about the copyright / license.
# 
#            Simple In-Memory Cache
#

import json, httpcore, tables, times

## Type definition for the cache response
type
    ResponseMessage* = object
        code*: string
        resCode*: HttpCode
        message*: string
        value*: JsonNode

var mcCache* = initTable[string, ResponseMessage]()

proc setCache*(key: JsonNode; value: JsonNode; expire: uint = 300) = 
    echo ""

proc getCache*(key: JsonNode;) = 
    echo ""

proc deleteCache*(key: JsonNode;) = 
    echo ""

proc clearCache*() : bool = 
    try:
        mcCache = initTable[string, ResponseMessage]()
        result = true
    except:
        result = false
