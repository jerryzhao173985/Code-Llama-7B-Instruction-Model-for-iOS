import SwiftUI
import LLM

class Bot: LLM {
    convenience init() {
        let url = Bundle.main.url(forResource: "codellama-7b-instruct.Q4_K_M", withExtension: "gguf")!
//        let systemPrompt = "You are an expert programmer that writes precise, accurate and concise code."
        let systemPrompt = "Provide function in Python."
        self.init(from: url, template: .llama(systemPrompt),
                  /*topK: 10, topP: 0.9,*/ temp: 0.1, historyLimit: 1, maxTokenCount: 512)
    }
        
        /*let url = Bundle.main.url(forResource: "codellama-7b-python.Q4_K_M", withExtension: "gguf")!*/
//        let systemPrompt = "Provide function in Python."
//        let systemPrompt = "You are an expert programmer that writes precise, accurate and concise code."
//        let systemPrompt = "你是一个乐于助人的AI，非常乐于解答各种问题。"
        /*self.init(from: url, template: Template(
                        user: ("", " [/INST]"),
                        bot: (" ", "</s><s>[INST] "),
                        stopSequence: "</s>",
                        systemPrompt: nil,
                        shouldDropLast: true),
                  topK: 10, topP: 0.9, temp: 0.1, historyLimit: 2, maxTokenCount: 150)*/
        
//        topK: 10, topP: 0.9, temp: 0.7,
//    topK: Int32 = 40,
//    topP: Float = 0.95,
//    temp: Float = 0.8,
//    historyLimit: Int = 8,
//    maxTokenCount: Int32 = 2048
//    }
}

struct BotView: View {
    @ObservedObject var bot: Bot
    @State var input = "Write a simple function on decomposition of integers."
//    Write a simple function on recurrent neural networks with PyTorch.
//    "Write a simple function on linear regression with pytorch."
//    "Write a simple function on decomposition of integers to prime numbers."
//    "Write a vgg16 neural network model with pytorch."
    init(_ bot: Bot) { self.bot = bot }
    func respond() { Task { await bot.respond(to: input) } }
    func stop() { bot.stop() }
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView { Text(bot.output).monospaced() }
            Spacer()
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8).foregroundStyle(.thinMaterial).frame(height: 40)
                    TextField("input", text: $input).padding(8)
                }
                Button(action: respond) { Image(systemName: "paperplane.fill") }
                Button(action: stop) { Image(systemName: "xmark") }
            }
        }.frame(maxWidth: .infinity).padding()
    }
}

struct ContentView: View {
    var body: some View {
        BotView(Bot())
    }
}
