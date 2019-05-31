package com.webratio.webapp;

public class Tipo implements java.io.Serializable {
    /** Serial version identifier. */
    private static final long serialVersionUID = 1L;

    private java.lang.Integer _oid;

    private java.lang.String _nome;

    private java.sql.Timestamp _createdAt;

    private java.sql.Timestamp _updatedAt;

    private java.lang.Integer _oidCategoria;

    private java.util.Set _tipoToEstabelecimentos = new java.util.HashSet();

    private com.webratio.webapp.Categoria _tipoToCategoria;

    private float _searchScore;

    public java.lang.Integer getOid() {
        return _oid;
    }

    public void setOid(java.lang.Integer _oid) {
        this._oid = _oid;
    }

    public java.lang.String getNome() {
        return _nome;
    }

    public void setNome(java.lang.String _nome) {
        this._nome = _nome;
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

    public java.lang.Integer getOidCategoria() {
        return _oidCategoria;
    }

    public void setOidCategoria(java.lang.Integer _oidCategoria) {
        this._oidCategoria = _oidCategoria;
    }

    public java.util.Set getTipoToEstabelecimentos() {
        return _tipoToEstabelecimentos;
    }

    public void setTipoToEstabelecimentos(java.util.Set _tipoToEstabelecimentos) {
        this._tipoToEstabelecimentos = _tipoToEstabelecimentos;
    }

    public com.webratio.webapp.Categoria getTipoToCategoria() {
        return _tipoToCategoria;
    }

    public void setTipoToCategoria(com.webratio.webapp.Categoria _tipoToCategoria) {
        this._tipoToCategoria = _tipoToCategoria;
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
        if (_nome != null)
            sb.append("nome=" + _nome + ',');
        if (_createdAt != null)
            sb.append("createdAt=" + _createdAt + ',');
        if (_updatedAt != null)
            sb.append("updatedAt=" + _updatedAt + ',');
        if (_oidCategoria != null)
            sb.append("oidCategoria=" + _oidCategoria + ',');
        n = sb.length() - 1;
        if (sb.charAt(n) == ',') {
            sb.setCharAt(n, ']');
        } else if (sb.charAt(n) == '[') {
            sb.deleteCharAt(n);
        }
        return sb.toString();
    }

    public boolean equals(java.lang.Object obj) {
        if (!(obj instanceof com.webratio.webapp.Tipo)) {
            return false;
        }
        com.webratio.webapp.Tipo __other = (com.webratio.webapp.Tipo) obj;
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
