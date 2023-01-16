//
//  TestPage.swift
//  DevAppMobile
//
//  Created by Jean Hubert ABA'A on 12/12/2022.
//

import SwiftUI

struct TestPage: View {
    @StateObject var fetchObjects = FetchObjects()
    var body: some View {
        ScrollView{
            Text("All objects").font(.title)
            List(db_objects, id: \.idobject) { item in
                        VStack(alignment: .leading) {
                            Text(item.image)
                                .font(.headline)
                            Text(item.author)
                        }
                    }
        }
        .onAppear {
            Task{
                await fetchObjects.fetchObjects()
            }
        }
        
    }
}

struct TestPage_Previews: PreviewProvider {
    static var previews: some View {
        TestPage()
    }
}
