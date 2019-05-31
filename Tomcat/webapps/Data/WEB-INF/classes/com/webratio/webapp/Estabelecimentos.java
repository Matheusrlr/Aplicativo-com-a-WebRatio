package com.webratio.webapp;

public class Estabelecimentos implements java.io.Serializable {
    /** Serial version identifier. */
    private static final long serialVersionUID = 1L;

    private java.lang.Integer _oid;

    private java.lang.Integer _valor;

    private java.lang.String _telefone;

    private java.lang.String _link;

    private java.lang.String _endereco;

    private java.lang.String _descricao;

    private java.lang.String _nome;

    private java.lang.String _logoRef;

    private java.lang.Object _logo;

    private java.sql.Timestamp _createdAt;

    private java.sql.Timestamp _updatedAt;

    private java.lang.Integer _oidTipo;

    private com.webratio.webapp.Tipo _estabelecimentosToTipo;

    private float _searchScore;

    public java.lang.Integer getOid() {
        return _oid;
    }

    public void setOid(java.lang.Integer _oid) {
        this._oid = _oid;
    }

    public java.lang.Integer getValor() {
        return _valor;
    }

    public void setValor(java.lang.Integer _valor) {
        this._valor = _valor;
    }

    public java.lang.String getTelefone() {
        return _telefone;
    }

    public void setTelefone(java.lang.String _telefone) {
        this._telefone = _telefone;
    }

    public java.lang.String getLink() {
        return _link;
    }

    public void setLink(java.lang.String _link) {
        this._link = _link;
    }

    public java.lang.String getEndereco() {
        return _endereco;
    }

    public void setEndereco(java.lang.String _endereco) {
        this._endereco = _endereco;
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

    public java.lang.Integer getOidTipo() {
        return _oidTipo;
    }

    public void setOidTipo(java.lang.Integer _oidTipo) {
        this._oidTipo = _oidTipo;
    }

    public com.webratio.webapp.Tipo getEstabelecimentosToTipo() {
        return _estabelecimentosToTipo;
    }

    public void setEstabelecimentosToTipo(com.webratio.webapp.Tipo _estabelecimentosToTipo) {
        this._estabelecimentosToTipo = _estabelecimentosToTipo;
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
        if (_valor != null)
            sb.append("valor=" + _valor + ',');
        if (_telefone != null)
            sb.append("telefone=" + _telefone + ',');
        if (_link != null)
            sb.append("link=" + _link + ',');
        if (_endereco != null)
            sb.append("endereco=" + _endereco + ',');
        if (_descricao != null)
            sb.append("descricao=" + _descricao + ',');
        if (_nome != null)
            sb.append("nome=" + _nome + ',');
        if (_logo != null)
            sb.append("logo=" + _logo + ',');
        if (_createdAt != null)
            sb.append("createdAt=" + _createdAt + ',');
        if (_updatedAt != null)
            sb.append("updatedAt=" + _updatedAt + ',');
        if (_oidTipo != null)
            sb.append("oidTipo=" + _oidTipo + ',');
        n = sb.length() - 1;
        if (sb.charAt(n) == ',') {
            sb.setCharAt(n, ']');
        } else if (sb.charAt(n) == '[') {
            sb.deleteCharAt(n);
        }
        return sb.toString();
    }

    public boolean equals(java.lang.Object obj) {
        if (!(obj instanceof com.webratio.webapp.Estabelecimentos)) {
            return false;
        }
        com.webratio.webapp.Estabelecimentos __other = (com.webratio.webapp.Estabelecimentos) obj;
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
