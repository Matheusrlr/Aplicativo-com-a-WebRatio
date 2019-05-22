package com.webratio.webapp;

public class Device implements java.io.Serializable {
    /** Serial version identifier. */
    private static final long serialVersionUID = 1L;

    private java.lang.Integer _oid;

    private java.lang.String _deviceID;

    private java.lang.String _notificationDeviceID;

    private java.lang.String _model;

    private java.lang.String _platform;

    private java.lang.String _platformVersion;

    private java.lang.String _browser;

    private com.webratio.webapp.User _deviceToUser;

    private float _searchScore;

    public java.lang.Integer getOid() {
        return _oid;
    }

    public void setOid(java.lang.Integer _oid) {
        this._oid = _oid;
    }

    public java.lang.String getDeviceID() {
        return _deviceID;
    }

    public void setDeviceID(java.lang.String _deviceID) {
        this._deviceID = _deviceID;
    }

    public java.lang.String getNotificationDeviceID() {
        return _notificationDeviceID;
    }

    public void setNotificationDeviceID(java.lang.String _notificationDeviceID) {
        this._notificationDeviceID = _notificationDeviceID;
    }

    public java.lang.String getModel() {
        return _model;
    }

    public void setModel(java.lang.String _model) {
        this._model = _model;
    }

    public java.lang.String getPlatform() {
        return _platform;
    }

    public void setPlatform(java.lang.String _platform) {
        this._platform = _platform;
    }

    public java.lang.String getPlatformVersion() {
        return _platformVersion;
    }

    public void setPlatformVersion(java.lang.String _platformVersion) {
        this._platformVersion = _platformVersion;
    }

    public java.lang.String getBrowser() {
        return _browser;
    }

    public void setBrowser(java.lang.String _browser) {
        this._browser = _browser;
    }

    public com.webratio.webapp.User getDeviceToUser() {
        return _deviceToUser;
    }

    public void setDeviceToUser(com.webratio.webapp.User _deviceToUser) {
        this._deviceToUser = _deviceToUser;
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
        if (_deviceID != null)
            sb.append("deviceID=" + _deviceID + ',');
        if (_notificationDeviceID != null)
            sb.append("notificationDeviceID=" + _notificationDeviceID + ',');
        if (_model != null)
            sb.append("model=" + _model + ',');
        if (_platform != null)
            sb.append("platform=" + _platform + ',');
        if (_platformVersion != null)
            sb.append("platformVersion=" + _platformVersion + ',');
        if (_browser != null)
            sb.append("browser=" + _browser + ',');
        n = sb.length() - 1;
        if (sb.charAt(n) == ',') {
            sb.setCharAt(n, ']');
        } else if (sb.charAt(n) == '[') {
            sb.deleteCharAt(n);
        }
        return sb.toString();
    }

    public boolean equals(java.lang.Object obj) {
        if (!(obj instanceof com.webratio.webapp.Device)) {
            return false;
        }
        com.webratio.webapp.Device __other = (com.webratio.webapp.Device) obj;
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
