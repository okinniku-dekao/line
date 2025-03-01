import ComposableArchitecture

@Reducer
public struct WalletTopFeature {
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action: Equatable {}
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
