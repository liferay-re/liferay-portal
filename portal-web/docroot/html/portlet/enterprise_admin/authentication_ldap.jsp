<%
/**
 * Copyright (c) 2000-2007 Liferay, Inc. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
%>

<script type="text/javascript">
	function <portlet:namespace />updateDefaultLdap() {
		var baseProviderURL = "";
		var baseDN = "";
		var principal = "";
		var credentials = "";
		var searchFilter = "";
		var userMappings = "";

		var ldapType = document.<portlet:namespace />fm.<portlet:namespace />defaultLdap.selectedIndex;

		if (ldapType == 1) {
			baseProviderURL = "ldap://localhost:10389";
			baseDN = "dc=example,dc=com";
			principal = "uid=admin,ou=system";
			credentials = "secret";
			searchFilter = "(mail=@email_address@)";
			userMappings = "screenName=cn\npassword=userPassword\nemailAddress=mail\nfirstName=givenName\nlastName=sn\njobTitle=title";
		}
		else if (ldapType == 2) {
			baseProviderURL = "ldap://localhost:389";
			baseDN = "dc=example,dc=com";
			principal = "admin";
			credentials = "secret";
			searchFilter = "(&(objectCategory=person)(sAMAccountName=@user_id@))";
			userMappings = "fullName=cn\nscreenName=sAMAccountName\nemailAddress=userprincipalname";
		}
		else if (ldapType == 3) {
			url = "ldap://localhost:389";
			baseDN = "";
			principal = "cn=admin,ou=test";
			credentials = "secret";
			searchFilter = "(mail=@email_address@)";
			userMappings = "screenName=cn\npassword=userPassword\nemailAddress=mail\nfirstName=givenName\nlastName=sn\njobTitle=title";
		}

		if ((ldapType >= 1) && (ldapType <= 3)) {
			document.<portlet:namespace />fm.<portlet:namespace />baseProviderURL.value = baseProviderURL;
			document.<portlet:namespace />fm.<portlet:namespace />baseDN.value = baseDN;
			document.<portlet:namespace />fm.<portlet:namespace />principal.value = principal;
			document.<portlet:namespace />fm.<portlet:namespace />credentials.value = credentials;
			document.<portlet:namespace />fm.<portlet:namespace />searchFilter.value = searchFilter;
			document.<portlet:namespace />fm.<portlet:namespace />userMappings.value = userMappings;
		}
	}

	jQuery(
		function() {
			Liferay.Util.toggleBoxes('<portlet:namespace />importEnabledCheckbox', '<portlet:namespace />importEnabledSettings');
		}
	);
</script>

<liferay-ui:error key="ldapAuthentication" message="failed-to-bind-to-the-ldap-server-with-given-values" />

<table class="liferay-table">
<tr>
	<td>
		<liferay-ui:tabs
			names="connection-settings"
			param="tabs1"
			refresh="<%= false %>"
		>
			<liferay-ui:section>
				<table class="liferay-table">
					<tr>
						<td>
							<liferay-ui:message key="enabled" />
						</td>
						<td>
							<liferay-ui:input-checkbox param="enabled" defaultValue='<%= ParamUtil.getBoolean(request, "enabled", PortalLDAPUtil.isAuthEnabled(company.getCompanyId())) %>' />
						</td>
					</tr>
					<tr>
						<td>
							<liferay-ui:message key="required" />
						</td>
						<td>
							<liferay-ui:input-checkbox param="required" defaultValue='<%= ParamUtil.getBoolean(request, "required", PrefsPropsUtil.getBoolean(company.getCompanyId(), PropsUtil.LDAP_AUTH_REQUIRED)) %>' />
						</td>
					</tr>
					</table>

					<br />

					<liferay-ui:message key="the-ldap-url-format-is" />

					<br /><br />

					<table class="liferay-table">
					<tr>
						<td>
							<liferay-ui:message key="base-provider-url" />
						</td>
						<td>
							<input class="liferay-input-text" name="<portlet:namespace />baseProviderURL" type="text" value='<%= ParamUtil.getString(request, "baseProviderURL", PrefsPropsUtil.getString(company.getCompanyId(), PropsUtil.LDAP_BASE_PROVIDER_URL)) %>' />
						</td>
					</tr>
					<tr>
						<td>
							<liferay-ui:message key="base-dn" />
						</td>
						<td>
							<input class="liferay-input-text" name="<portlet:namespace />baseDN" type="text" value='<%= ParamUtil.getString(request, "baseDN", PrefsPropsUtil.getString(company.getCompanyId(), PropsUtil.LDAP_BASE_DN)) %>' />
						</td>
					</tr>
					<tr>
						<td>
							<liferay-ui:message key="principal" />
						</td>
						<td>
							<input class="liferay-input-text" name="<portlet:namespace />principal" type="text" value='<%= ParamUtil.getString(request, "principal", PrefsPropsUtil.getString(company.getCompanyId(), PropsUtil.LDAP_SECURITY_PRINCIPAL)) %>' />
						</td>
					</tr>
					<tr>
						<td>
							<liferay-ui:message key="credentials" />
						</td>
						<td>
							<input class="liferay-input-text" name="<portlet:namespace />credentials" type="password" value='<%= ParamUtil.getString(request, "credentials", PrefsPropsUtil.getString(company.getCompanyId(), PropsUtil.LDAP_SECURITY_CREDENTIALS)) %>' />
						</td>
					</tr>
					</table>

					<br />

					<liferay-ui:message key="enter-the-search-filter-that-will-be-used-to-test-the-validity-of-a-user" />

					<br /><br />

					<textarea class="liferay-textarea" name="<portlet:namespace />searchFilter"><%= ParamUtil.getString(request, "searchFilter", PrefsPropsUtil.getString(company.getCompanyId(), PropsUtil.LDAP_AUTH_SEARCH_FILTER)) %></textarea>

					<br /><br />

					<liferay-ui:message key="enter-the-encryption-algorithm-used-for-passwords-stored-in-the-ldap-server" />

					<br /><br />

					<select name="<portlet:namespace />passwordEncryptionAlgorithm">
						<option value=""></option>

						<%
						String passwordEncryptionAlgorithm = PrefsPropsUtil.getString(company.getCompanyId(), PropsUtil.LDAP_AUTH_PASSWORD_ENCRYPTION_ALGORITHM);

						String[] algorithmTypes = PropsUtil.getArray(PropsUtil.LDAP_AUTH_PASSWORD_ENCRYPTION_ALGORITHM_TYPES);

						for (int i = 0; i < algorithmTypes.length; i++) {
						%>

							<option <%= passwordEncryptionAlgorithm.equals(algorithmTypes[i]) ? "selected" : "" %> value="<%= algorithmTypes[i] %>"><%= algorithmTypes[i] %></option>

						<%
						}
						%>

					</select>

					<br /><br />

					<liferay-ui:message key="if-the-user-is-valid-and-the-user-exists-in-the-ldap-server-but-not-in-liferay" />

					<br /><br />

					<textarea class="liferay-textarea" name="<portlet:namespace />userMappings"><%= ParamUtil.getString(request, "userMappings", PrefsPropsUtil.getString(company.getCompanyId(), PropsUtil.LDAP_USER_MAPPINGS)) %></textarea>

					<br /><br />

					<table class="liferay-table">
					<tr>
						<td>
							<select name="<portlet:namespace />defaultLdap">
								<option></option>
								<option>Apache Directory Server</option>
								<option>Microsoft Active Directory Server</option>
								<option>Novell eDirectory</option>
							</select>
						</td>
						<td>
							<input type="button" value="<liferay-ui:message key="reset-values" />" onClick="<portlet:namespace />updateDefaultLdap();" />
						</td>
					</tr>
					</table>
				</liferay-ui:section>
			</liferay-ui:tabs>

			<br />

			<liferay-ui:tabs
				names="import-settings"
				param="tabs1"
				refresh="<%= false %>"
			>
				<liferay-ui:section>
					<table class="liferay-table">
					<tr>
						<td>
							<liferay-ui:message key="import-enabled" />
						</td>
						<td>
							<liferay-ui:input-checkbox param="importEnabled" defaultValue='<%= ParamUtil.getBoolean(request, "importEnabled", PrefsPropsUtil.getBoolean(company.getCompanyId(), PropsUtil.LDAP_IMPORT_ENABLED)) %>' />
						</td>
					</tr>
					<tbody id="<portlet:namespace />importEnabledSettings">
						<tr>
							<td>
								<liferay-ui:message key="import-on-startup-enabled" />
							</td>
							<td>
								<liferay-ui:input-checkbox param="importOnStartup" defaultValue='<%= ParamUtil.getBoolean(request, "importOnStartup", PrefsPropsUtil.getBoolean(company.getCompanyId(), PropsUtil.LDAP_IMPORT_ON_STARTUP)) %>' />
							</td>
						</tr>
						<tr>
							<td>
								<liferay-ui:message key="import-interval" />
							</td>
							<td>

								<%
								long importInterval = ParamUtil.getLong(request, "importInterval", PrefsPropsUtil.getLong(company.getCompanyId(), PropsUtil.LDAP_IMPORT_INTERVAL));
								%>

								<select name="<portlet:namespace />importInterval">
									<option value="0" <%= (importInterval == 0) ? " selected " : "" %>><liferay-ui:message key="disabled" /></option>
									<option value="5" <%= (importInterval == 5) ? " selected " : "" %>>5 <liferay-ui:message key="minutes" /></option>
									<option value="10" <%= (importInterval == 10) ? " selected " : "" %>>10 <liferay-ui:message key="minutes" /></option>
									<option value="30" <%= (importInterval == 30) ? " selected " : "" %>>30 <liferay-ui:message key="minutes" /></option>
									<option value="60" <%= (importInterval == 60) ? " selected " : "" %>>1 <liferay-ui:message key="hour" /></option>
									<option value="120" <%= (importInterval == 120) ? " selected " : "" %>>2 <liferay-ui:message key="hours" /></option>
									<option value="180" <%= (importInterval == 180) ? " selected " : "" %>>3 <liferay-ui:message key="hours" /></option>
								</select>
							</td>
						</tr>
						<tr>
							<td>
								<liferay-ui:message key="import-user-search-filter" />
							</td>
							<td>
								<input class="liferay-input-text" name="<portlet:namespace />importUserSearchFilter" type="text" value='<%= ParamUtil.getString(request, "importUserSearchFilter", PrefsPropsUtil.getString(company.getCompanyId(), PropsUtil.LDAP_IMPORT_USER_SEARCH_FILTER)) %>' />
							</td>
						</tr>
						<tr>
							<td>
								<liferay-ui:message key="import-group-search-filter" />
							</td>
							<td>
								<input class="liferay-input-text" name="<portlet:namespace />importGroupSearchFilter" type="text" value='<%= ParamUtil.getString(request, "importGroupSearchFilter", PrefsPropsUtil.getString(company.getCompanyId(), PropsUtil.LDAP_IMPORT_GROUP_SEARCH_FILTER)) %>' />
							</td>
						</tr>
					</tbody>
					</table>
				</liferay-ui:section>
			</liferay-ui:tabs>

			<br />

			<liferay-ui:tabs
				names="export-settings"
				param="tabs1"
				refresh="<%= false %>"
			>
				<liferay-ui:section>
					<table class="liferay-table">
					<tr>
						<td>
							<liferay-ui:message key="export-enabled" />
						</td>
						<td>
							<liferay-ui:input-checkbox param="exportEnabled" defaultValue='<%= ParamUtil.getBoolean(request, "exportEnabled", PrefsPropsUtil.getBoolean(company.getCompanyId(), PropsUtil.LDAP_EXPORT_ENABLED)) %>' />
						</td>
					</tr>
					<tr>
						<td>
							<liferay-ui:message key="users-dn" />
						</td>
						<td>
							<input class="liferay-input-text" name="<portlet:namespace />usersDn" type="text" value='<%= ParamUtil.getString(request, "usersDn", PrefsPropsUtil.getString(company.getCompanyId(), PropsUtil.LDAP_USERS_DN)) %>' />
						</td>
					</tr>
					<tr>
						<td>
							<liferay-ui:message key="user-default-object-classes" />
						</td>
						<td>
							<input class="liferay-input-text" name="<portlet:namespace />userDefaultObjectClasses" type="text" value='<%= ParamUtil.getString(request, "userDefaultObjectClasses", PrefsPropsUtil.getString(company.getCompanyId(), PropsUtil.LDAP_USER_DEFAULT_OBJECT_CLASSES)) %>' />
						</td>
					</tr>
					</table>
				</liferay-ui:section>
			</liferay-ui:tabs>

			<br />

			<liferay-ui:tabs
				names="password-policy"
				param="tabs1"
				refresh="<%= false %>"
			>
				<liferay-ui:section>
					<table class="liferay-table">
					<tr>
						<td>
							<liferay-ui:message key="use-ldap-password-policy" />
						</td>
						<td>
							<liferay-ui:input-checkbox param="passwordPolicyEnabled" defaultValue='<%= ParamUtil.getBoolean(request, "passwordPolicyEnabled", PrefsPropsUtil.getBoolean(company.getCompanyId(), PropsUtil.LDAP_PASSWORD_POLICY_ENABLED)) %>' />
						</td>
					</tr>
					</table>
				</liferay-ui:section>
			</liferay-ui:tabs>

			<br />

			<input type="button" value="<liferay-ui:message key="save" />" onClick="<portlet:namespace />saveSettings('updateLdap');" />
</td>
</tr>
</table>