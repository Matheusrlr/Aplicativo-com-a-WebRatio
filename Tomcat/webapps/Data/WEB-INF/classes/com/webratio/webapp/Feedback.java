package com.webratio.webapp;

public class Feedback implements java.io.Serializable {
    /** Serial version identifier. */
    private static final long serialVersionUID = 1L;

    private java.lang.Integer _oid;

    private java.lang.String _sugestao;

    private java.lang.Boolean _sexo;

    private java.sql.Date _dataNasc;

    private java.lang.String _email;

    private java.lang.String _matrCula;

    private java.lang.String _sobrenome;

    private java.lang.String _nome;

    private java.sql.Timestamp _createdAt;

    private java.sql.Timestamp _updatedAt;

    private com.webratio.webapp.Menu _feedbackToMenu;

    private float _searchScore;

    public java.lang.Integer getOid() {
        return _oid;
    }

    public void setOid(java.lang.Integer _oid) {
        this._oid = _oid;
    }

    public java.lang.String getSugestao() {
        return _sugestao;
    }

    public void setSugestao(java.lang.String _sugestao) {
        this._sugestao = _sugestao;
    }

    public java.lang.Boolean getSexo() {
        return _sexo;
    }

    public void setSexo(java.lang.Boolean _sexo) {
        this._sexo = _sexo;
    }

    public java.sql.Date getDataNasc() {
        return _dataNasc;
    }

    public void setDataNasc(java.sql.Date _dataNasc) {
        this._dataNasc = _dataNasc;
    }

    public java.lang.String getEmail() {
        return _email;
    }

    public void setEmail(java.lang.String _email) {
        this._email = _email;
    }

    public java.lang.String getMatrCula() {
        return _matrCula;
    }

    public void setMatrCula(java.lang.String _matrCula) {
        this._matrCula = _matrCula;
    }

    public java.lang.String getSobrenome() {
        return _sobrenome;
    }

    public void setSobrenome(java.lang.String _sobrenome) {
        this._sobrenome = _sobrenome;
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

    public com.webratio.webapp.Menu getFeedbackToMenu() {
        return _feedbackToMenu;
    }

    public void setFeedbackToMenu(com.webratio.webapp.Menu _feedbackToMenu) {
        this._feedbackToMenu = _feedbackToMenu;
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
        if (_sugestao != null)
            sb.append("sugestao=" + _sugestao + ',');
        if (_sexo != null)
            sb.append("sexo=" + _sexo + ',');
        if (_dataNasc != null)
            sb.append("dataNasc=" + _dataNasc + ',');
        if (_email != null)
            sb.append("email=" + _email + ',');
        if (_matrCula != null)
            sb.append("matrCula=" + _matrCula + ',');
        if (_sobrenome != null)
            sb.append("sobrenome=" + _sobrenome + ',');
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
        if (!(obj instanceof com.webratio.webapp.Feedback)) {
            return false;
        }
        com.webratio.webapp.Feedback __other = (com.webratio.webapp.Feedback) obj;
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
