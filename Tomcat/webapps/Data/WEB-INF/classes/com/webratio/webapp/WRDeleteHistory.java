package com.webratio.webapp;

public class WRDeleteHistory implements java.io.Serializable {
    /** Serial version identifier. */
    private static final long serialVersionUID = 1L;

    private java.lang.Integer _OID;

    private java.lang.String _objectId;

    private java.lang.String _classId;

    private java.sql.Timestamp _deletedAt;

    private float _searchScore;

    public java.lang.Integer getOID() {
        return _OID;
    }

    public void setOID(java.lang.Integer _OID) {
        this._OID = _OID;
    }

    public java.lang.String getObjectId() {
        return _objectId;
    }

    public void setObjectId(java.lang.String _objectId) {
        this._objectId = _objectId;
    }

    public java.lang.String getClassId() {
        return _classId;
    }

    public void setClassId(java.lang.String _classId) {
        this._classId = _classId;
    }

    public java.sql.Timestamp getDeletedAt() {
        return _deletedAt;
    }

    public void setDeletedAt(java.sql.Timestamp _deletedAt) {
        this._deletedAt = _deletedAt;
    }

    public float getSearchScore() {
        return _searchScore;
    }

    public void setSearchScore(float _searchScore) {
        this._searchScore = _searchScore;
    }

    public String toString() {
        java.lang.StringBuffer sb = new java.lang.StringBuffer();
        sb.append(super.toString());
        int n = sb.length() - 1;
        if (sb.charAt(n) == ']') {
            sb.setCharAt(n, ',');
        } else {
            sb.append('[');
        }
        if (_OID != null)
            sb.append("OID=" + _OID + ',');
        if (_objectId != null)
            sb.append("objectId=" + _objectId + ',');
        if (_classId != null)
            sb.append("classId=" + _classId + ',');
        if (_deletedAt != null)
            sb.append("deletedAt=" + _deletedAt + ',');
        n = sb.length() - 1;
        if (sb.charAt(n) == ',') {
            sb.setCharAt(n, ']');
        } else if (sb.charAt(n) == '[') {
            sb.deleteCharAt(n);
        }
        return sb.toString();
    }

    public boolean equals(java.lang.Object obj) {
        if (!(obj instanceof com.webratio.webapp.WRDeleteHistory)) {
            return false;
        }
        com.webratio.webapp.WRDeleteHistory __other = (com.webratio.webapp.WRDeleteHistory) obj;
        java.lang.Object key = null;
        java.lang.Object otherKey = null;
        key = this.getOID();
        otherKey = __other.getOID();
        if (key == null) {
            if (otherKey != null) {
                return false;
            }
        } else {
            if (otherKey == null) {
                return false;
            } else if (!key.equals(otherKey)) {
                return false;
            }
        }
        return true;
    }

    public int hashCode() {
        int hashCode = 0;
        java.lang.Object key = null;
        key = this.getOID();
        if (key != null) {
            hashCode |= key.hashCode();
        }
        return hashCode;
    }
}
