import SwiftUI

public struct ResultView<Success, Failure>: View where Failure: Error {
    let result: Result<Success, Failure>
    
    public init(result: Result<Success, Failure>) {
        self.result = result
    }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
            
            switch result {
            case .failure(let error):
                VStack{
                    Image.operation(success: false)
                        .resizable()
                        .foregroundColor(.red)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Text(error.localizedDescription)
                }
            default:
                Image.operation(success: true)
                    .resizable()
                    .foregroundColor(.green)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
        }
        .padding()
    }
}
