Locales = {}

function _(str, ...)  -- Translate string

	if Locales[Core.Settings.Language] ~= nil then

		if Locales[Core.Settings.Language][str] ~= nil then
			return string.format(Locales[Core.Settings.Language][str], ...)
		else
			return 'Translation [' .. Core.Settings.Language .. '][' .. str .. '] does not exist'
		end

	else
		return 'Locale [' .. Core.Settings.Language .. '] does not exist'
	end

end

function _U(str, ...) -- Translate string first char uppercase
	return tostring(_(str, ...):gsub("^%l", string.upper))
end
