Enable_type_text_to_accept= true
Enable_Only_1_language= false
Default_language_number= 1

privs_to_grant={"shout","interact","home",}


--default languages: english=1, spanish=2, france=3,germany=4

-- Add "," between the rules





arok_text={
	{
		"Italiano",
		"Continua",
		"Si!",
		"No",
		"Accetti le regole del server?",
		"Accetto le regole",
		"Scrivi quello che segue nel campo testo: ",
		"Type the key to play, then press Continue",
		"Devi accettare le regole per giocare in questo server. Sarai benvenuto una prossima volta",
		"Ora hai il permesso di giocare!",
		"Date tutti il benvenuto a",
		"che � appena entrato nel server!",
		"Regole del server ,Non chiedere privilegi o diritti amministrativi ,Non usare un linguaggio o nomi offensivi ,No trolling ,No griefing ,No uccisioni senza motivo ,Non rubare o usare nomi di altri utenti ,No hacking ,Non importunare inutilmente gli admin ,no spam",
		"Cancella",
		"Benvenuto",
		"usa /rules per visualizzarlo di nuovo",
	},
	{
		"English",
		"Continue",
		"Yes!",
		"No",
		"Do you accept the server rules?",
		"i agree to the rules",
		"Type this in the textbox: ",
		"Type the key to play, then press Continue",
		"You have to agree the rules to play this server. You are welcome back to next time",
		"You have now permission to play!",
		"Everyone, please welcome",
		"to the server!",
		"Server Rules ,No ask for privs or admin stuff ,No swearing or bad names ,No trolling ,No griefing ,No killing ,No stealing or steal people's usernames ,No hacking ,Don't mess up with moderators or admins ,no spam",
		"Cancel",
		"Welcome",
		"type /rules to see this again",
	},
	{
		"francais",
		"Continuer",
		"Oui!",
		"Non",
		"Acceptez-vous les regles du serveur?",
		"je suis daccord sur les regles",
		"Taper dans la zone de texte: ",
		"Tapez la cle a jouer, puis appuyez sur Continuer",
		"Vous devez accepter les regles pour jouer a ce serveur. Vous etes les bienvenus dans la prochaine fois",
		"Vous ne lavez pas la permission de jouer!",
		"Jokainen, ota tervetulleita",
		"palvelimelle!",
		"Regles de serveur, No demandent des trucs prive ou admin, Aucune prestation de serment ou de mauvais noms, Non a la traine, Non griefing, Ne pas tuer, ne pas voler ou de voler les noms dutilisateur des gens, No piratage, ne plaisante pas avec les moderateurs et admins, pas de spam",
		"Annuler",
		"Bienvenue",
		"Type /rules pour voir ce message",
	},
	{
		"Deutschland",
		"Fortsetzen",
		"Ja!",
		"Nein",
		"Haben Sie die Server-Regeln akzeptieren?",
		"ich stimme den regeln",
		"Geben Sie diese in das Textfeld ein: ",
		"Geben Sie den Schlussel zu spielen, drucken Sie weiter",
		"Sie mussen die Regeln akzeptieren diesen Server zu spielen. Sie sind willkommen in das nachste Mal wieder",
		"Sie haben keine Berechtigung zu spielen!",
		"Jeder, bitte begruBen",
		"an den Server!",
		"Server-Regeln, stellen keine fur private oder Admin-Zeug, kein Fluchen oder schlechten Namen, kein Schleppen, kein griefing, keine Totung, kein Diebstahl oder Volksbenutzernamen stehlen, kein Hacking, Verwirren Sie nicht mit Moderatoren oder Administratoren up, kein spam",
		"Stornieren",
		"Herzlich willkommen",
		"Typ /rules dieses wieder zu sehen",
	},
}
agreerules_form=""
function create_agreerules_form(i)
	local form="size[8,5;] "
	local aot="," .. arok_text[i][7]
	local doacc="," .. arok_text[i][5]
	if Enable_type_text_to_accept==true then
		aot=aot ..",".. arok_text[i][6]
		doacc=""
	else aot="" end
	form=form.."dropdown[-0.1,-0.1;8.5,1;rules;" .. arok_text[i][13].. ", " .. arok_text[i][16].. "," .. aot .. doacc .. ";1]"

	if Enable_type_text_to_accept==true then
	form=form.." field[0.5,3;7.5,2;text;" .. arok_text[i][8]..";]"
	form=form.." button_exit[2,4;2,2;yes;" .. arok_text[i][2].. "]"
	form=form.." button[4,4;2,2;no;" .. arok_text[i][14] .. "]"
	else
	form=form.." button_exit[2,4;2,2;yes;" .. arok_text[i][3] .. "]"
	form=form.." button[4,4;2,2;no;".. arok_text[i][4] .."]"
	end

	form=form.." field[0,0;0,0;lang;;" .. i .."]"
	if Enable_Only_1_language==false then
		local cpos=0
		for ii = 1, #arok_text, 1 do
			form=form.." button_exit[" ..cpos ..",1;2,2;lang" .. (ii) .. ";" .. arok_text[ii][1] .. "]"
			cpos=cpos+2
		end
	end
	agreerules_form=form
end

minetest.register_on_player_receive_fields(function(player, form, pressed)

	if form== "AgreeRulesYesNoForm" then
		local name=player:get_player_name()
		local privs = minetest.get_player_privs(name)
		local i=tonumber(pressed.lang)
		if i==nil then
			i=Default_language_number
		end

		if pressed.lang1 or pressed.lang2 or pressed.lang3 or pressed.lang4 then
			local n=1
			if pressed.lang2 then n=2 end
			if pressed.lang3 then n=3 end
			if pressed.lang4 then n=4 end
			minetest.after((0.1), function(n)
				create_agreerules_form(n)
				return minetest.show_formspec(name, "AgreeRulesYesNoForm",agreerules_form)
			end, n)
			return true
		end

		if not (pressed.no or pressed.quit) and (pressed.rules or (pressed.text~="" and pressed.text~=arok_text[i][6])) then
			minetest.after((0.1), function(i)
				create_agreerules_form(i)
				return minetest.show_formspec(name, "AgreeRulesYesNoForm",agreerules_form)
			end, i)
			return true
		end

		if (pressed.no or pressed.quit) and not (pressed.yes or pressed.key_enter) then
			return minetest.kick_player(name,arok_text[i][9])
		end

		if Enable_type_text_to_accept==true then
			if pressed.text~=arok_text[i][6] then
			minetest.after((0.1), function(i)
				create_agreerules_form(i)
				return minetest.show_formspec(name, "AgreeRulesYesNoForm",agreerules_form)
			end, i)
			return true
			end
		end

		for i, v in pairs(privs_to_grant) do
			privs[v]=true
		end
		minetest.set_player_privs(name, privs)
		minetest.chat_send_player(name,arok_text[i][15] .." "..name.. " " .. arok_text[i][10])
		minetest.chat_send_all(arok_text[Default_language_number][11] .." "..name.." " .. arok_text[Default_language_number][12])
	end
end)

minetest.register_on_joinplayer(function(player)
	if minetest.check_player_privs(player:get_player_name(), {interact=true})==false then
		create_agreerules_form(Default_language_number)
		minetest.show_formspec(player:get_player_name(), "AgreeRulesYesNoForm",agreerules_form)
	end
end)

minetest.register_chatcommand("rules", {
	params = "",
	description = "Rules",
	func = function(name, param)
	create_agreerules_form(Default_language_number)
	minetest.after((0.1), function()
		return minetest.show_formspec(name, "AgreeRulesYesNoForm",agreerules_form)
	end)
end})
