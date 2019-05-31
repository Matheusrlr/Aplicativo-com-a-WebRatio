package com.webratio.webapp;

public class Menu implements java.io.Serializable {
    /** Serial version identifier. */
    private static final long serialVersionUID = 1L;

    private java.lang.Integer _oid;

    private java.sql.Timestamp _createdAt;

    private java.sql.Timestamp _updatedAt;

    private java.lang.String _logoRef;

    private java.lang.Object _logo;

    private java.util.Set _menuToFeedback = new java.util.HashSet();

    private float _searchScore;

    public java.lang.Integer getOid() {
        return _oid;
    }

    public void setOid(java.lang.Integer _oid) {
        this._oid = _oid;
    }

    public java.sql.Timestamp getCreatedAt() {
        return _createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp _createdAt) {
        this._createdAt = _createdAt;
    }

    public java.sql.Timestamp getUpdatedAt() {
        return _updatedAt;
    }

    public void setUpdatedAt(java.sql.Timestamp _updatedAt) {
        this._updatedAt = _updatedAt;
    }

    public java.lang.String getLogoRef() {
        return _logoRef;
    }

    public void setLogoRef(java.lang.String _logoRef) {
        this._logoRef = _logoRef;
    }

    public java.lang.Object getLogo() {
        return _logo;
    }

    public void setLogo(java.lang.Object _logo) {
        this._logo = _logo;
    }

    public java.util.Set getMenuToFeedback() {
        return _menuToFeedback;
    }

    public void setMenuToFeedback(java.util.Set _menuToFeedback) {
        this._menuToFeedback = _menuToFeedback;
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
        if (_oid != null)
            sb.append("oid=" + _oid + ',');
        if (_createdAt != null)
            sb.append("createdAt=" + _createdAt + ',');
        if (_updatedAt != null)
            sb.append("updatedAt=" + _updatedAt + ',');
        if (_logo != null)
            sb.append("logo=" + _logo + ',');
        n = sb.length() - 1;
        if (sb.charAt(n) == ',') {
            sb.setCharAt(n, ']');
        } else if (sb.charAt(n) == '[') {
            sb.deleteCharAt(n);
        }
        return sb.toString();
    }

    public boolean equals(java.lang.Object obj) {
        if (!(obj instanceof com.webratio.webapp.Menu)) {
            return false;
        }
        com.webratio.webapp.Menu __other = (com.webratio.webapp.Menu) obj;
        java.lang.Object key = null;
        java.lang.Object otherKey = null;
        key = this.getOid();
        otherKey = __other.getOid();
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
        key = this.getOid();
        if (key != null) {
            hashCode |= key.hashCode();
        }
        return hashCode;
    }
}
