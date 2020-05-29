#
#              mconnect solutions
#        (c) Copyright 2020 Abi Akindele (mconnect.biz)
#
#    See the file "LICENSE.md", included in this
#    distribution, for details about the copyright / license.
# 
#             Hash In-Memory Cache
#

import json, httpcore, tables

## Type definition for the cache response
type
    ResponseMessage* = object
        code*: string
        resCode*: HttpCode
        message*: string
        value*: JsonNode
  
var responseMessages* = initTable[string, ResponseMessage]()

proc setHashCache*() = 
    echo ""

proc getHashCache*() = 
    echo ""

proc deleteHashCache*() = 
    echo ""

proc clearHashCache*() = 
    echo ""
