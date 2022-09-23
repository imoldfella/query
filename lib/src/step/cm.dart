// translated from CodeMirror

enum MapMode {
  /// Map a position to a valid new position, even when its context
  /// was deleted.
  simple,

  /// Return null if deletion happens across the position.
  trackDel,

  /// Return null if the character _before_ the position is deleted.
  trackBefore,

  /// Return null if the character _after_ the position is deleted.
  trackAfter
}

class ChangeSpec {}

class ChangeSet {}


/*
export class ChangeDesc {
  // Sections are encoded as pairs of integers. The first is the
  // length in the current document, and the second is -1 for
  // unaffected sections, and the length of the replacement content
  // otherwise. So an insertion would be (0, n>0), a deletion (n>0,
  // 0), and a replacement two positive numbers.
  /// @internal
  protected constructor(
    /// @internal
    readonly sections: readonly number[]
  ) {}

  /// The length of the document before the change.
  get length() {
    let result = 0
    for (let i = 0; i < this.sections.length; i += 2) result += this.sections[i]
    return result
  }

  /// The length of the document after the change.
  get newLength() {
    let result = 0
    for (let i = 0; i < this.sections.length; i += 2) {
      let ins = this.sections[i + 1]
      result += ins < 0 ? this.sections[i] : ins
    }
    return result
  }

  /// False when there are actual changes in this set.
  get empty() { return this.sections.length == 0 || this.sections.length == 2 && this.sections[1] < 0 }

  /// Iterate over the unchanged parts left by these changes. `posA`
  /// provides the position of the range in the old document, `posB`
  /// the new position in the changed document.
  iterGaps(f: (posA: number, posB: number, length: number) => void) {
    for (let i = 0, posA = 0, posB = 0; i < this.sections.length;) {
      let len = this.sections[i++], ins = this.sections[i++]
      if (ins < 0) {
        f(posA, posB, len)
        posB += len
      } else {
        posB += ins
      }
      posA += len
    }
  }

  /// Iterate over the ranges changed by these changes. (See
  /// [`ChangeSet.iterChanges`](#state.ChangeSet.iterChanges) for a
  /// variant that also provides you with the inserted text.)
  /// `fromA`/`toA` provides the extent of the change in the starting
  /// document, `fromB`/`toB` the extent of the replacement in the
  /// changed document.
  ///
  /// When `individual` is true, adjacent changes (which are kept
  /// separate for [position mapping](#state.ChangeDesc.mapPos)) are
  /// reported separately.
  iterChangedRanges(f: (fromA: number, toA: number, fromB: number, toB: number) => void, individual = false) {
    iterChanges(this, f, individual)
  }

  /// Get a description of the inverted form of these changes.
  get invertedDesc() {
    let sections = []
    for (let i = 0; i < this.sections.length;) {
      let len = this.sections[i++], ins = this.sections[i++]
      if (ins < 0) sections.push(len, ins)
      else sections.push(ins, len)
    }
    return new ChangeDesc(sections)
  }

  /// Compute the combined effect of applying another set of changes
  /// after this one. The length of the document after this set should
  /// match the length before `other`.
  composeDesc(other: ChangeDesc) { return this.empty ? other : other.empty ? this : composeSets(this, other) }

  /// Map this description, which should start with the same document
  /// as `other`, over another set of changes, so that it can be
  /// applied after it. When `before` is true, map as if the changes
  /// in `other` happened before the ones in `this`.
  mapDesc(other: ChangeDesc, before = false): ChangeDesc { return other.empty ? this : mapSet(this, other, before) }

  /// Map a given position through these changes, to produce a
  /// position pointing into the new document.
  ///
  /// `assoc` indicates which side the position should be associated
  /// with. When it is negative or zero, the mapping will try to keep
  /// the position close to the character before it (if any), and will
  /// move it before insertions at that point or replacements across
  /// that point. When it is positive, the position is associated with
  /// the character after it, and will be moved forward for insertions
  /// at or replacements across the position. Defaults to -1.
  ///
  /// `mode` determines whether deletions should be
  /// [reported](#state.MapMode). It defaults to
  /// [`MapMode.Simple`](#state.MapMode.Simple) (don't report
  /// deletions).
  mapPos(pos: number, assoc?: number): number
  mapPos(pos: number, assoc: number, mode: MapMode): number | null
  mapPos(pos: number, assoc = -1, mode: MapMode = MapMode.Simple) {
    let posA = 0, posB = 0
    for (let i = 0; i < this.sections.length;) {
      let len = this.sections[i++], ins = this.sections[i++], endA = posA + len
      if (ins < 0) {
        if (endA > pos) return posB + (pos - posA)
        posB += len
      } else {
        if (mode != MapMode.Simple && endA >= pos &&
            (mode == MapMode.TrackDel && posA < pos && endA > pos ||
             mode == MapMode.TrackBefore && posA < pos ||
             mode == MapMode.TrackAfter && endA > pos)) return null
        if (endA > pos || endA == pos && assoc < 0 && !len)
          return pos == posA || assoc < 0 ? posB : posB + ins
        posB += ins
      }
      posA = endA
    }
    if (pos > posA) throw new RangeError(`Position ${pos} is out of range for changeset of length ${posA}`)
    return posB
  }

  /// Check whether these changes touch a given range. When one of the
  /// changes entirely covers the range, the string `"cover"` is
  /// returned.
  touchesRange(from: number, to = from): boolean | "cover" {
    for (let i = 0, pos = 0; i < this.sections.length && pos <= to;) {
      let len = this.sections[i++], ins = this.sections[i++], end = pos + len
      if (ins >= 0 && pos <= to && end >= from) return pos < from && end > to ? "cover" : true
      pos = end
    }
    return false
  }

  /// @internal
  toString() {
    let result = ""
    for (let i = 0; i < this.sections.length;) {
      let len = this.sections[i++], ins = this.sections[i++]
      result += (result ? " " : "") + len + (ins >= 0 ? ":" + ins : "")
    }
    return result
  }

  /// Serialize this change desc to a JSON-representable value.
  toJSON() { return this.sections }

  /// Create a change desc from its JSON representation (as produced
  /// by [`toJSON`](#state.ChangeDesc.toJSON).
  static fromJSON(json: any) {
    if (!Array.isArray(json) || json.length % 2 || json.some(a => typeof a != "number"))
      throw new RangeError("Invalid JSON representation of ChangeDesc")
    return new ChangeDesc(json as number[])
  }

  /// @internal
  static create(sections: readonly number[]) { return new ChangeDesc(sections) }
}

export class ChangeSet extends ChangeDesc {
  private constructor(
    sections: readonly number[],
    /// @internal
    readonly inserted: readonly Text[]
  ) {
    super(sections)
  }

  /// Apply the changes to a document, returning the modified
  /// document.
  apply(doc: Text) {
    if (this.length != doc.length) throw new RangeError("Applying change set to a document with the wrong length")
    iterChanges(this, (fromA, toA, fromB, _toB, text) => doc = doc.replace(fromB, fromB + (toA - fromA), text), false)
    return doc
  }

  mapDesc(other: ChangeDesc, before = false): ChangeDesc { return mapSet(this, other, before, true) }

  /// Given the document as it existed _before_ the changes, return a
  /// change set that represents the inverse of this set, which could
  /// be used to go from the document created by the changes back to
  /// the document as it existed before the changes.
  invert(doc: Text) {
    let sections = this.sections.slice(), inserted = []
    for (let i = 0, pos = 0; i < sections.length; i += 2) {
      let len = sections[i], ins = sections[i + 1]
      if (ins >= 0) {
        sections[i] = ins; sections[i + 1] = len
        let index = i >> 1
        while (inserted.length < index) inserted.push(Text.empty)
        inserted.push(len ? doc.slice(pos, pos + len) : Text.empty)
      }
      pos += len
    }
    return new ChangeSet(sections, inserted)
  }

  /// Combine two subsequent change sets into a single set. `other`
  /// must start in the document produced by `this`. If `this` goes
  /// `docA` → `docB` and `other` represents `docB` → `docC`, the
  /// returned value will represent the change `docA` → `docC`.
  compose(other: ChangeSet) { return this.empty ? other : other.empty ? this : composeSets(this, other, true) }

  /// Given another change set starting in the same document, maps this
  /// change set over the other, producing a new change set that can be
  /// applied to the document produced by applying `other`. When
  /// `before` is `true`, order changes as if `this` comes before
  /// `other`, otherwise (the default) treat `other` as coming first.
  ///
  /// Given two changes `A` and `B`, `A.compose(B.map(A))` and
  /// `B.compose(A.map(B, true))` will produce the same document. This
  /// provides a basic form of [operational
  /// transformation](https://en.wikipedia.org/wiki/Operational_transformation),
  /// and can be used for collaborative editing.
  map(other: ChangeDesc, before = false): ChangeSet { return other.empty ? this : mapSet(this, other, before, true) }

  /// Iterate over the changed ranges in the document, calling `f` for
  /// each, with the range in the original document (`fromA`-`toA`)
  /// and the range that replaces it in the new document
  /// (`fromB`-`toB`).
  ///
  /// When `individual` is true, adjacent changes are reported
  /// separately.
  iterChanges(f: (fromA: number, toA: number, fromB: number, toB: number, inserted: Text) => void, individual = false) {
    iterChanges(this, f, individual)
  }

  /// Get a [change description](#state.ChangeDesc) for this change
  /// set.
  get desc() { return ChangeDesc.create(this.sections) }

  /// @internal
  filter(ranges: readonly number[]) {
    let resultSections: number[] = [], resultInserted: Text[] = [], filteredSections: number[] = []
    let iter = new SectionIter(this)
    done: for (let i = 0, pos = 0;;) {
      let next = i == ranges.length ? 1e9 : ranges[i++]
      while (pos < next || pos == next && iter.len == 0) {
        if (iter.done) break done
        let len = Math.min(iter.len, next - pos)
        addSection(filteredSections, len, -1)
        let ins = iter.ins == -1 ? -1 : iter.off == 0 ? iter.ins : 0
        addSection(resultSections, len, ins)
        if (ins > 0) addInsert(resultInserted, resultSections, iter.text)
        iter.forward(len)
        pos += len
      }
      let end = ranges[i++]
      while (pos < end) {
        if (iter.done) break done
        let len = Math.min(iter.len, end - pos)
        addSection(resultSections, len, -1)
        addSection(filteredSections, len, iter.ins == -1 ? -1 : iter.off == 0 ? iter.ins : 0)
        iter.forward(len)
        pos += len
      }
    }
    return {changes: new ChangeSet(resultSections, resultInserted),
            filtered: ChangeDesc.create(filteredSections)}
  }

  /// Serialize this change set to a JSON-representable value.
  toJSON(): any {
    let parts: (number | [number, ...string[]])[] = []
    for (let i = 0; i < this.sections.length; i += 2) {
      let len = this.sections[i], ins = this.sections[i + 1]
      if (ins < 0) parts.push(len)
      else if (ins == 0) parts.push([len])
      else parts.push(([len] as [number, ...string[]]).concat(this.inserted[i >> 1].toJSON()) as any)
    }
    return parts
  }

  /// Create a change set for the given changes, for a document of the
  /// given length, using `lineSep` as line separator.
  static of(changes: ChangeSpec, length: number, lineSep?: string): ChangeSet {
    let sections: number[] = [], inserted: Text[] = [], pos = 0
    let total: ChangeSet | null = null

    function flush(force = false) {
      if (!force && !sections.length) return
      if (pos < length) addSection(sections, length - pos, -1)
      let set = new ChangeSet(sections, inserted)
      total = total ? total.compose(set.map(total)) : set
      sections = []; inserted = []; pos = 0
    }
    function process(spec: ChangeSpec) {
      if (Array.isArray(spec)) {
        for (let sub of spec) process(sub)
      } else if (spec instanceof ChangeSet) {
        if (spec.length != length)
          throw new RangeError(`Mismatched change set length (got ${spec.length}, expected ${length})`)
        flush()
        total = total ? total.compose(spec.map(total)) : spec
      } else {
        let {from, to = from, insert} = spec as {from: number, to?: number, insert?: string | Text}
        if (from > to || from < 0 || to > length)
          throw new RangeError(`Invalid change range ${from} to ${to} (in doc of length ${length})`)
        let insText = !insert ? Text.empty : typeof insert == "string" ? Text.of(insert.split(lineSep || DefaultSplit)) : insert
        let insLen = insText.length
        if (from == to && insLen == 0) return
        if (from < pos) flush()
        if (from > pos) addSection(sections, from - pos, -1)
        addSection(sections, to - from, insLen)
        addInsert(inserted, sections, insText)
        pos = to
      }
    }

    process(changes)
    flush(!total)
    return total!
  }

  /// Create an empty changeset of the given length.
  static empty(length: number) {
    return new ChangeSet(length ? [length, -1] : [], [])
  }

  /// Create a changeset from its JSON representation (as produced by
  /// [`toJSON`](#state.ChangeSet.toJSON).
  static fromJSON(json: any) {
    if (!Array.isArray(json)) throw new RangeError("Invalid JSON representation of ChangeSet")
    let sections = [], inserted = []
    for (let i = 0; i < json.length; i++) {
      let part = json[i]
      if (typeof part == "number") {
        sections.push(part, -1)
      } else if (!Array.isArray(part) || typeof part[0] != "number" || part.some((e, i) => i && typeof e != "string")) {
        throw new RangeError("Invalid JSON representation of ChangeSet")
      } else if (part.length == 1) {
        sections.push(part[0], 0)
      } else {
        while (inserted.length < i) inserted.push(Text.empty)
        inserted[i] = Text.of(part.slice(1))
        sections.push(part[0], inserted[i].length)
      }
    }
    return new ChangeSet(sections, inserted)
  }

  /// @internal
  static createSet(sections: readonly number[], inserted: readonly Text[]) {
    return new ChangeSet(sections, inserted)
  }
}

*/
