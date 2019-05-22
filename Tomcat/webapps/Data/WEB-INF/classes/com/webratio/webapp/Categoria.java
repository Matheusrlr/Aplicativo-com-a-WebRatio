package com.webratio.webapp;

public class Categoria implements java.io.Serializable {
    /** Serial version identifier. */
    private static final long serialVersionUID = 1L;

    private java.lang.Integer _oid;

    private java.lang.String _imagemRef;

    private java.lang.Object _imagem;

    private java.lang.String _descricao;

    private java.lang.String _nome;

    private java.sql.Timestamp _createdAt;

    private java.sql.Timestamp _updatedAt;

    private java.util.Set _categoriaToTipo = new java.util.HashSet();

    private float _searchScore;

    public java.lang.Integer getOid() {
        return _oid;
    }

    public void setOid(java.lang.Integer _oid) {
        this._oid = _oid;
    }

    public java.lang.String getImagemRef() {
        return _imagemRef;
    }

    public void setImagemRef(java.lang.String _imagemRef) {
        this._imagemRef = _imagemRef;
    }

    public java.lang.Object getImagem() {
        return _imagem;
    }

    public void setImagem(java.lang.Object _imagem) {
        this._imagem = _imagem;
    }

    public java.lang.String getDescricao() {
        return _descricao;
    }

    public void setDescricao(java.lang.String _descricao) {
        this._descricao = _descricao;
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

    public java.util.Set getCategoriaToTipo() {
        return _categoriaToTipo;
    }

    public void setCategoriaToTipo(java.util.Set _categoriaToTipo) {
        this._categoriaToTipo = _categoriaToTipo;
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
        if (_imagem != null)
            sb.append("imagem=" + _imagem + ',');
        if (_descricao != null)
            sb.append("descricao=" + _descricao + ',');
        if (_nome != null)
            sb.append("nome=" + _nome + ',');
        if (_createdAt != null)
            sb.append("createdAt=" + _createdAt + ',');
        if (_updatedAt != null)
            sb.append("updatedAt=" + _updatedAt + ',');
        n = sb.length() - 1;
        if (sb.charAt(n) == ',') {
            sb.setCharAt(n, ']');
        } else if (sb.charAt(n) == '[') {
            sb.deleteCharAt(n);
        }
        return sb.toString();
    }

    public boolean equals(java.lang.Object obj) {
        if (!(obj instanceof com.webratio.webapp.Categoria)) {
            return false;
        }
        com.webratio.webapp.Categoria __other = (com.webratio.webapp.Categoria) obj;
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
