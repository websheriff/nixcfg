{ ... }: {
  sops.templates."lldap/lldap-deployment" = {
    content = ''
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: lldap
        namespace: lldap
        labels:
          app: lldap
      spec:
        replicas: 1
        strategy:
          type: RollingUpdate
        selector:
          matchLabels:
            app: lldap
        template:
          metadata:
            labels:
              app: lldap
          spec:
            containers:
              - name: lldap
                image: lldap/lldap:v0.6.3
                imagePullPolicy: IfNotPresent
                ports:
                  - containerPort: 3890
                    name: ldap
                  - containerPort: 17170
                    name: http
                env:
                  - name: TZ
                    value: America/Chicago
                  - name: LLDAP_DATABASE_URL
                    valueFrom:
                      secretKeyRef:
                        name: lldap-db
                        key: url
                  - name: LLDAP_DATABASE_PASSWORD
                    valueFrom:
                      secretKeyRef:
                        name: lldap-db
                        key: password
                  - name: LLDAP_LDAP_BASE_DN
                    valueFrom:
                      secretKeyRef:
                        name: lldap-secret
                        key: base-dn
                  - name: LLDAP_JWT_SECRET
                    valueFrom:
                      secretKeyRef:
                        name: lldap-secret
                        key: jwt-secret
                  - name: LLDAP_KEY_SEED
                    valueFrom:
                      secretKeyRef:
                        name: lldap-secret
                        key: key-seed
                  - name: LLDAP_LDAP_USER_PASS
                    valueFrom:
                      secretKeyRef:
                        name: lldap-secret-admin
                        key: password
    '';
  };
}
