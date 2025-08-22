describe OmniAuth::GovukOneLogin::Client do
  it "initializes" do
    idp_configuration = MockIdpConfiguration.new
    allow(OmniAuth::GovukOneLogin::IdpConfiguration).to receive(:new)
      .with(
        idp_base_url: IdpFixtures.base_url,
        signing_algorithm: IdpFixtures.signing_algorithm
      )
      .and_return(idp_configuration)

    subject = described_class.new(
      client_id: ClientFixtures.client_id,
      idp_base_url: IdpFixtures.base_url,
      private_key: ClientFixtures.private_key,
      redirect_uri: ClientFixtures.redirect_uri,
      private_key_kid: ClientFixtures.private_key_kid,
      scope: "openid,email",
      ui_locales: "en",
      vtr: ["Cl.Cm"],
      pkce: true,
      userinfo_claims: [],
      signing_algorithm: "ES256"
    )

    expect(subject.client_id).to eq(ClientFixtures.client_id)
    expect(subject.idp_configuration).to eq(idp_configuration)
    expect(subject.private_key).to eq(ClientFixtures.private_key)
    expect(subject.redirect_uri).to eq(ClientFixtures.redirect_uri)
    expect(subject.private_key_kid).to eq(ClientFixtures.private_key_kid)
    expect(subject.scope).to eq("openid,email")
    expect(subject.ui_locales).to eq("en")
    expect(subject.vtr).to eq(["Cl.Cm"])
    expect(subject.pkce).to eq(true)
    expect(subject.userinfo_claims).to eq([])
    expect(subject.signing_algorithm).to eq("ES256")
  end
end
