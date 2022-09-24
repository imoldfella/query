tuples are retrieved in streams from servers that store our subscriptions

We build these in something like materialize shared arrangements, where each consistent view becomes an immutable snapshot.

There is a second trace of snapshots that represents our local changes. These are discarded when new updates are applied.

The update process must include the javascript sandbox.
to update:
  send all updates to js
  js will return with all the local steps it applied, and which ones it dropped.
  db will adjust its local queue accordingly

Indexing is deferred if it is not observed.

Every tuple has a tid. The tid is a server/time pair stored as varints. They are stored clustered on this tid.

Every tuple contains a reference to its container. A container is a database/branch. The database defines admin and owner. The branch defines read & writer roles. (owner may or may not be a reader)

Tuple's may contain references to blobs. The reference is server/time. The blob may written as a delta against blobs in the same database branch, but not in any other branch. 

Branches can define tags representing a snapshot in time. 

Each branch may publish files and directories from a tag. These publications may be encrypted. Applications can define how branch data is converted into publications. The core library defines functions for publishing markdown data. Publications are placed in public namespace even if they are encrypted. The application can determine how to generate names in the publication namespace while ensuring they are unique.

The application may also request url rewriting to create pretty names for viewers. A pretty prefix can be renamed into the publication namespace so that viewers only see the pretty name prefix with the publication suffix.

Url rewriting is expensive and leaks metadata, so it is handled with a service worker for viewers. The server will manage renaming for search engines.

# api considerations




subscriptions are unwanted metadata, but we can't push without them? could there be a client side push that exposes less? ultimately some servers should be physically controlled and explode if tampered with.

tabstyle {
  sql: ''
  }

spreadsheet:
  create table (id, tab, tabstyle)
  create table cell (id, tab, key, variant)  #key=rowId+colId
  create table float (id, tab, row, offset , variant)

document:
  

dirty reads allows reading uncommitted transactions. Transactions are only 

