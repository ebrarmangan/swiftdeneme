import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var showingLoginView = true
    
    var body: some View {
        if !isLoggedIn {
            AuthView()
        } else {
            MainTabView()
        }
    }
}

struct AuthView: View {
    @State private var isRegistering = false
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var showingVerification = false
    @State private var showingProfileSetup = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isRegistering ? "Kayıt Ol" : "Giriş Yap")
                .font(.largeTitle)
                .bold()
            
            TextField("Telefon Numarası", text: $phoneNumber)
                .keyboardType(.phonePad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if showingVerification {
                TextField("Doğrulama Kodu", text: $verificationCode)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            Button(action: {
                if !showingVerification {
                    // Telefon doğrulama kodu gönder
                    showingVerification = true
                } else {
                    // Kodu doğrula ve devam et
                    showingProfileSetup = true
                }
            }) {
                Text(showingVerification ? "Doğrula" : "Devam Et")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button(action: {
                isRegistering.toggle()
            }) {
                Text(isRegistering ? "Zaten hesabın var mı? Giriş yap" : "Hesabın yok mu? Kayıt ol")
                    .foregroundColor(.blue)
            }
        }
        .sheet(isPresented: $showingProfileSetup) {
            ProfileSetupView()
        }
    }
}

struct ProfileSetupView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var gender = "Seçiniz"
    @State private var birthDate = Date()
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    let genderOptions = ["Seçiniz", "Kadın", "Erkek", "Diğer"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Kişisel Bilgiler")) {
                    TextField("Ad", text: $firstName)
                    TextField("Soyad", text: $lastName)
                    TextField("E-posta", text: $email)
                        .keyboardType(.emailAddress)
                    
                    Picker("Cinsiyet", selection: $gender) {
                        ForEach(genderOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    DatePicker("Doğum Tarihi",
                             selection: $birthDate,
                             displayedComponents: .date)
                }
                
                Button(action: {
                    // Bilgileri kaydet
                    isLoggedIn = true
                }) {
                    Text("Kayıt Ol")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
                .disabled(firstName.isEmpty || lastName.isEmpty || email.isEmpty || gender == "Seçiniz")
                .listRowBackground(Color.blue)
            }
            .navigationTitle("Profil Bilgileri")
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Sohbet")
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Harita")
                }
            
            EmergencyView()
                .tabItem {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Acil")
                }
        }
    }
}

// Diğer görünümler için örnek yapılar
struct ChatView: View {
    var body: some View {
        Text("Sohbet Sayfası")
    }
}

struct MapView: View {
    var body: some View {
        Text("Harita Sayfası")
    }
}

struct EmergencyView: View {
    var body: some View {
        Text("Acil Durum Sayfası")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
