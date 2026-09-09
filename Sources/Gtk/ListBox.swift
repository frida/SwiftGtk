import CGtk
import GLib

public typealias ListBoxRowFilter = (ListBoxRowRef) -> Bool

@usableFromInline typealias ListBoxRowFilterClosureHolder = ClosureHolder<ListBoxRowRef, Bool>

public typealias ListBoxRowHeaderUpdate = (ListBoxRowRef, ListBoxRowRef?) -> Void

@usableFromInline typealias ListBoxRowHeaderUpdateClosureHolder = DualClosureHolder<ListBoxRowRef, ListBoxRowRef?, Void>

public extension ListBoxProtocol {
    /// Set the filter function for this list box
    /// - Parameter filterFunction: a function or closure that takes a reference to a row and returns whether that row should be visible
    @inlinable func setFilterFunc(_ filterFunction: @escaping ListBoxRowFilter) {
        _connect(filterFunc: ListBoxRowFilterClosureHolder(filterFunction)) {
            guard let row = $0, let holderPtr = $1 else { return 0 }
            let holder = Unmanaged<ListBoxRowFilterClosureHolder>.fromOpaque(holderPtr).takeUnretainedValue()
            return holder.call(ListBoxRowRef(row)) ? 1 : 0
        }
    }

    /// Set the header function for this list box
    /// - Parameter headerFunction: a function or closure that takes a reference to a row and the row preceding it, and sets the header of the former
    @inlinable func setHeaderFunc(_ headerFunction: @escaping ListBoxRowHeaderUpdate) {
        _connect(updateHeaderFunc: ListBoxRowHeaderUpdateClosureHolder(headerFunction)) {
            guard let row = $0, let holderPtr = $2 else { return }
            let holder = Unmanaged<ListBoxRowHeaderUpdateClosureHolder>.fromOpaque(holderPtr).takeUnretainedValue()
            holder.call(ListBoxRowRef(row), $1.map(ListBoxRowRef.init))
        }
    }

    /// Connection helper function
    @usableFromInline internal func _connect(filterFunc: ListBoxRowFilterClosureHolder, handler: @convention(c) @escaping (UnsafeMutablePointer<GtkListBoxRow>?, gpointer?) -> gboolean) {
        let opaqueHolder = Unmanaged.passRetained(filterFunc).toOpaque()
        set(filterFunc: handler, userData: opaqueHolder, destroy: {
            if let swift = $0 {
                let holder = Unmanaged<ListBoxRowFilterClosureHolder>.fromOpaque(swift)
                holder.release()
            }
        })
    }

    /// Connection helper function
    @usableFromInline internal func _connect(updateHeaderFunc: ListBoxRowHeaderUpdateClosureHolder, handler: @convention(c) @escaping (UnsafeMutablePointer<GtkListBoxRow>?, UnsafeMutablePointer<GtkListBoxRow>?, gpointer?) -> Void) {
        let opaqueHolder = Unmanaged.passRetained(updateHeaderFunc).toOpaque()
        setHeaderFunc(updateHeader: handler, userData: opaqueHolder, destroy: {
            if let swift = $0 {
                let holder = Unmanaged<ListBoxRowHeaderUpdateClosureHolder>.fromOpaque(swift)
                holder.release()
            }
        })
    }
}
