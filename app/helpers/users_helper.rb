#
# Copyright 2011 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

module UsersHelper

  def mask_password user
    return "" if user.password.nil?
    user.password.gsub(/./, "&#9679;")
  end

  def organization_select(org_id=nil, optional=true)
    choices = current_user.allowed_organizations.map {|a| [a.name, a.id]}
    if optional
      selected = org_id
      prompt = nil
      choices.unshift ['No Default Organization', nil]
    else
      selected = org_id || current_organization.id
      prompt = _('Select Organization')
    end
    select(:org_id, "org_id", choices,
           {:prompt => prompt, :id=>"org_field",
           :selected => selected})
  end

  def locale_select(locale=nil)
    choices = FastGettext.available_locales
    selected = locale
    choices.unshift [_('Use Browser Locale'), choices]
    select(:locale, "locale", choices,
           {:prompt => nil, :id=>"locale_field",
           :selected => selected})
  end

end
