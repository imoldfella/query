 


we could have multiple synopsis.
maybe each encompasses the smaller one so we don't have extra read?

terms
term->
[term:[docid][startPos], term:[docid] ]
[pos]

there is another tradeoff problem: the pos vector is compressed, the startPos is compressed. 
two start bytes are not strictly a count by subtracting. but its a pretty good estimate probably?

what about packing everything with the document except the basic term->docid?
maybe a weight.

# the tradeoff here is complicated. we could interleave doc, in general we need this anyway for relevancy.
[term:docid:start]


stored fields:
[start]
[........]

[startDocument]
[document]

