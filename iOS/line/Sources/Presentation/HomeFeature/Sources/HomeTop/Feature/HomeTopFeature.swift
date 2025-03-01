import ComposableArchitecture

@Reducer
public struct HomeTopFeature {
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
